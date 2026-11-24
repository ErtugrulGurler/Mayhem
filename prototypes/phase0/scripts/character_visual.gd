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
const SEWalkRig = preload("res://scripts/se_walk_rig.gd")

var facing_index := 2
var frame_index := 0
var animation_phase := 0.0
var movement_amount := 0.0
var walking := false
var sprite: Sprite2D
var se_rig: Node2D
var _se_active := false
var _preview_actor := Vector2.ZERO

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
	se_rig = SEWalkRig.new()
	se_rig.name = "SEWalkRig"
	add_child(se_rig)
	refresh_sprite()

func update_motion(speed_ratio: float, direction: Vector2, delta: float) -> void:
	if not direction.is_zero_approx():
		# Canvas coordinates: E, SE, S, SW, W, NW, N, NE.
		facing_index = posmod(roundi(direction.angle() / (PI / 4.0)), 8)
	movement_amount = clampf(speed_ratio, 0.0, 1.0)
	walking = movement_amount > MOTION_THRESHOLD
	if walking:
		animation_phase = fposmod(animation_phase + maxf(delta, 0.0) * ANIMATION_FPS * movement_amount, FRAME_COUNT)
		frame_index = floori(animation_phase)
	else:
		animation_phase = 0.0
		frame_index = 0
	refresh_sprite()
	if facing_index == 1:
		var actor := get_parent() as CharacterBody2D
		if actor != null and actor.is_physics_processing():
			if not _se_active: se_rig.reset(actor.global_position)
			se_rig.advance(actor.global_position,actor.get_real_velocity(),delta)
		else:
			if not _se_active: se_rig.reset(_preview_actor)
			var velocity := SEWalkRig.SE*movement_amount*220.0
			_preview_actor += velocity*maxf(delta,0)
			se_rig.advance(_preview_actor,velocity,delta)
	_se_active = facing_index == 1

func refresh_sprite() -> void:
	if not is_instance_valid(sprite): return
	# Only SE switches renderer. All other atlas rows and playback stay intact.
	sprite.visible = facing_index != 1
	se_rig.visible = facing_index == 1
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
