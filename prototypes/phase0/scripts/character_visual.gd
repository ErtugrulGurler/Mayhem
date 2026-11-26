extends Node2D
## One atlas sprite for all eight directions. Physics and controls stay in Player.
## Supplied eight-frame test artwork is shown in source order without mirroring.

const WALK_ATLAS: Texture2D = preload("res://assets/characters/mayhem_soldier/mayhem_walk_8dir_8f.png")
const IDLE_ATLAS: Texture2D = preload("res://assets/characters/mayhem_soldier/mayhem_idle_8dir.png")
const FRAME_SIZE := Vector2(256, 288)
const FOOT_ANCHOR := Vector2(128, 272)
const WORLD_SCALE := 0.36
const FRAME_COUNT := 8
const FRAME_DURATION := 0.095
const ANIMATION_FPS := 1.0 / FRAME_DURATION
const MOTION_THRESHOLD := 0.02

var facing_index := 2
var frame_index := 0
var animation_phase := 0.0
var movement_amount := 0.0
var walking := false
var sprite: Sprite2D
var right_walk_test: Texture2D
var test_phase := 0.0
const RIGHT_WALK_PATH := "res://assets/characters/mayhem_sag_4k.png"
const TEST_FPS := 6.25
var right_cell := Vector2.ZERO
var right_feet: Array[Vector2] = []
var right_scale := WORLD_SCALE
const RIGHT_ALPHA_THRESHOLD := 32
static var _right_cache: Dictionary = {}

func _load_right_walk_test() -> void:
	# Imported project resource only: Android exports never access Downloads.
	if not ResourceLoader.exists(RIGHT_WALK_PATH): return
	var texture := load(RIGHT_WALK_PATH) as Texture2D
	configure_right_walk(texture)

func configure_right_walk(texture: Texture2D) -> bool:
	right_walk_test = null
	right_feet.clear()
	if texture == null: return false
	if _right_cache.get("texture") == texture:
		right_cell = _right_cache.cell
		right_feet = _right_cache.feet.duplicate()
		right_scale = _right_cache.scale
		right_walk_test = texture
		return true
	var dimensions := Vector2i(texture.get_size())
	if dimensions.x < 2 or dimensions.y < 2 or dimensions.x % 2 != 0 or dimensions.y % 2 != 0:
		return false
	var image := texture.get_image()
	if image == null or image.is_empty(): return false
	if image.is_compressed() and image.decompress() != OK: return false
	image.convert(Image.FORMAT_RGBA8)
	var pixels := image.get_data()
	var cell := dimensions / 2
	var feet: Array[Vector2] = []
	var maximum_height := 0
	for index in range(4):
		var at := Vector2i(index % 2, index / 2) * cell
		# Ignore near-transparent source dust when measuring; never alter pixels.
		var bounds := opaque_bounds(pixels,dimensions.x,Rect2i(at,cell))
		if not bounds.has_area(): return false
		feet.append(Vector2(bounds.position.x+bounds.size.x*0.5,bounds.end.y))
		maximum_height = maxi(maximum_height, bounds.size.y)
	var reference := IDLE_ATLAS.get_image().get_region(Rect2i(0, 0, 256, 288)).get_used_rect()
	right_scale = reference.size.y * WORLD_SCALE / maximum_height
	right_cell = Vector2(cell)
	right_feet = feet
	right_walk_test = texture
	# Measure once per imported texture, not once per spawned scene/frame.
	_right_cache = {"texture":texture,"cell":right_cell,"feet":right_feet.duplicate(),"scale":right_scale}
	return true

func opaque_bounds(pixels: PackedByteArray, width: int, area: Rect2i) -> Rect2i:
	var minimum := area.size
	var maximum := Vector2i(-1,-1)
	for y in range(area.size.y):
		var offset := ((area.position.y+y)*width+area.position.x)*4+3
		for x in range(area.size.x):
			if pixels[offset+x*4] < RIGHT_ALPHA_THRESHOLD: continue
			minimum.x = mini(minimum.x,x)
			minimum.y = mini(minimum.y,y)
			maximum.x = maxi(maximum.x,x)
			maximum.y = maxi(maximum.y,y)
	if maximum.x < 0: return Rect2i()
	return Rect2i(minimum,maximum-minimum+Vector2i.ONE)

func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.name = "SoldierAtlas"
	sprite.centered = false
	sprite.region_enabled = true
	sprite.region_filter_clip_enabled = true
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	sprite.scale = Vector2.ONE * WORLD_SCALE
	sprite.position = -FOOT_ANCHOR * WORLD_SCALE
	add_child(sprite)
	_load_right_walk_test()
	refresh_sprite()

func update_motion(speed_ratio: float, direction: Vector2, delta: float) -> void:
	if not direction.is_zero_approx():
		# Canvas coordinates: E, SE, S, SW, W, NW, N, NE.
		facing_index = posmod(roundi(direction.angle() / (PI / 4.0)), 8)
	movement_amount = clampf(speed_ratio, 0.0, 1.0)
	walking = movement_amount > MOTION_THRESHOLD
	if walking:
		test_phase = fposmod(test_phase + maxf(delta, 0.0) * TEST_FPS * movement_amount, 4.0)
		animation_phase = fposmod(animation_phase + maxf(delta, 0.0) * ANIMATION_FPS * movement_amount, FRAME_COUNT)
		frame_index = floori(animation_phase)
	else:
		test_phase = 0.0
		animation_phase = 0.0
		frame_index = 0
	refresh_sprite()

func refresh_sprite() -> void:
	if not is_instance_valid(sprite): return
	if walking and facing_index == 0 and right_walk_test != null:
		sprite.texture = right_walk_test
		sprite.scale = Vector2.ONE * right_scale
		var test_frame := floori(test_phase)
		sprite.position = -right_feet[test_frame] * right_scale
		sprite.region_rect = Rect2(Vector2(test_frame % 2, floori(float(test_frame) / 2.0)) * right_cell, right_cell)
		return
	sprite.scale = Vector2.ONE * WORLD_SCALE
	sprite.position = -FOOT_ANCHOR * WORLD_SCALE
	if walking:
		sprite.texture = WALK_ATLAS
		sprite.region_rect = Rect2(Vector2(frame_index, facing_index) * FRAME_SIZE, FRAME_SIZE)
	else:
		sprite.texture = IDLE_ATLAS
		sprite.region_rect = Rect2(Vector2(facing_index * FRAME_SIZE.x, 0), FRAME_SIZE)

func _draw() -> void:
	# Ground shadow remains outside the animated artwork and its fixed foot anchor.
	var points := PackedVector2Array()
	for i in range(25):
		var angle := i * TAU / 24.0
		points.append(Vector2(cos(angle) * 18.0, -3.0 + sin(angle) * 5.0))
	draw_colored_polygon(points, Color(0.05, 0.09, 0.07, 0.22))
