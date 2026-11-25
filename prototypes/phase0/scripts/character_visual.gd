extends Node2D
## Mayhem Phase 0: original 8-direction artwork remains the safe fallback.
## Optional Ludo ZIP from Android Downloads supplies 4-direction run/punch.
const WALK_ATLAS: Texture2D = preload("res://assets/characters/mayhem_soldier/mayhem_walk_8dir_8f.png")
const IDLE_ATLAS: Texture2D = preload("res://assets/characters/mayhem_soldier/mayhem_idle_8dir.png")
const FRAME_SIZE := Vector2(256, 288)
const FOOT_ANCHOR := Vector2(128, 272)
const WORLD_SCALE := 0.36
const FRAME_COUNT := 8
const ANIMATION_FPS := 1.0 / 0.095
const MOTION_THRESHOLD := 0.02

# Source sprites are 3 x 3 cells, each 542 x 646. Half-size at import to
# avoid keeping eight ~3MP RGBA textures in Android graphics memory.
const IMPORT_CELL := Vector2(271, 323)
const IMPORT_SCALE := 0.3
const IMPORT_FOOT_ANCHOR := Vector2(135.5, 303)
const IMPORT_FPS := 11.0
const PUNCH_FPS := 12.0
const IMPORT_PATHS := [
    "res://MayhemAsker_Godot.zip",
    "/storage/emulated/0/Download/MayhemAsker_Godot.zip",
    "/storage/emulated/0/Downloads/MayhemAsker_Godot.zip",
    "/sdcard/Download/MayhemAsker_Godot.zip"
]

var facing_index := 2
var frame_index := 0
var animation_phase := 0.0
var movement_amount := 0.0
var walking := false
var sprite: Sprite2D
var imported: Dictionary = {}
var using_import := false
var punch_active := false
var punch_seconds := 0.0

func _ready() -> void:
    sprite = Sprite2D.new()
    sprite.name = "SoldierAtlas"
    sprite.centered = false
    sprite.region_enabled = true
    sprite.region_filter_clip_enabled = true
    sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
    add_child(sprite)
    using_import = _try_import_zip()
    if using_import:
        sprite.scale = Vector2.ONE * IMPORT_SCALE
        sprite.position = -IMPORT_FOOT_ANCHOR * IMPORT_SCALE
        print("MAYHEM: Ludo run/punch package active.")
    else:
        sprite.scale = Vector2.ONE * WORLD_SCALE
        sprite.position = -FOOT_ANCHOR * WORLD_SCALE
        print("MAYHEM: Ludo ZIP not found/readable; using original soldier artwork.")
    refresh_sprite()

func _try_import_zip() -> bool:
    var filenames := ["run_down", "run_up", "run_left", "run_right", "punch_down", "punch_up", "punch_left", "punch_right"]
    for candidate in IMPORT_PATHS:
        if not FileAccess.file_exists(candidate):
            continue
        var zip := ZIPReader.new()
        if zip.open(candidate) != OK:
            continue
        var textures: Dictionary = {}
        var complete := true
        for filename in filenames:
            var data := zip.read_file("MayhemAsker_Godot/MayhemAsker/%s.png" % filename)
            if data.is_empty():
                complete = false
                break
            var source := Image.new()
            if source.load_png_from_buffer(data) != OK:
                complete = false
                break
            if source.get_width() != 1626 or source.get_height() != 1938:
                complete = false
                break
            source.resize(813, 969, Image.INTERPOLATE_LANCZOS)
            textures[filename] = ImageTexture.create_from_image(source)
        zip.close()
        if complete and textures.size() == 8:
            imported = textures
            return true
    return false

func request_punch() -> void:
    if not using_import or punch_active:
        return
    punch_active = true
    punch_seconds = 0.0
    refresh_sprite()

func update_motion(speed_ratio: float, direction: Vector2, delta: float) -> void:
    if not direction.is_zero_approx():
        # E, SE, S, SW, W, NW, N, NE (canvas coordinates)
        facing_index = posmod(roundi(direction.angle() / (PI / 4.0)), 8)
    movement_amount = clampf(speed_ratio, 0.0, 1.0)
    walking = movement_amount > MOTION_THRESHOLD
    if punch_active:
        punch_seconds += maxf(delta, 0.0)
        if punch_seconds >= 9.0 / PUNCH_FPS:
            punch_active = false
            punch_seconds = 0.0
    if walking:
        var fps := IMPORT_FPS if using_import else ANIMATION_FPS
        animation_phase = fposmod(animation_phase + maxf(delta, 0.0) * fps * movement_amount, float(9 if using_import else FRAME_COUNT))
        frame_index = floori(animation_phase)
    else:
        animation_phase = 0.0
        frame_index = 0
    refresh_sprite()

func _four_direction() -> String:
    match facing_index:
        0, 1, 7:
            return "right"
        2:
            return "down"
        3, 4, 5:
            return "left"
        _:
            return "up"

func refresh_sprite() -> void:
    if not is_instance_valid(sprite):
        return
    if using_import:
        var prefix := "punch_" if punch_active else "run_"
        sprite.texture = imported[prefix + _four_direction()]
        var frame := mini(floori(punch_seconds * PUNCH_FPS), 8) if punch_active else (frame_index if walking else 0)
        sprite.region_rect = Rect2(Vector2((frame % 3) * IMPORT_CELL.x, floori(float(frame) / 3.0) * IMPORT_CELL.y), IMPORT_CELL)
    elif walking:
        sprite.texture = WALK_ATLAS
        sprite.region_rect = Rect2(Vector2(frame_index, facing_index) * FRAME_SIZE, FRAME_SIZE)
    else:
        sprite.texture = IDLE_ATLAS
        sprite.region_rect = Rect2(Vector2(facing_index * FRAME_SIZE.x, 0), FRAME_SIZE)

func _draw() -> void:
    var points := PackedVector2Array()
    for i in range(25):
        var angle := i * TAU / 24.0
        points.append(Vector2(cos(angle) * 18.0, -3.0 + sin(angle) * 5.0))
    draw_colored_polygon(points, Color(0.05, 0.09, 0.07, 0.22))
