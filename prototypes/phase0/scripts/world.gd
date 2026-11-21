extends Node2D

const PropScene = preload("res://scripts/world_prop.gd")
const WORLD_SIZE := Vector2(2400, 1600)
@onready var player: CharacterBody2D = $Actors/Player
@onready var controls: Node = $InputRouter

func _ready() -> void:
	# Static, deterministic layout; the spawn and trail are always unobstructed.
	var trees := [Vector2(170, 340), Vector2(370, 240), Vector2(650, 460), Vector2(890, 570), Vector2(1120, 520), Vector2(1480, 390), Vector2(1770, 310), Vector2(2100, 270), Vector2(2270, 840), Vector2(2040, 1050), Vector2(1730, 1180), Vector2(1440, 1080), Vector2(1010, 1230), Vector2(620, 1340), Vector2(300, 1310), Vector2(180, 740), Vector2(2180, 1390)]
	for i in range(trees.size()): add_prop("tree", trees[i], i)
	for point in [Vector2(1040, 780), Vector2(1450, 900), Vector2(670, 710), Vector2(1690, 570), Vector2(1900, 890), Vector2(440, 1130), Vector2(800, 1100)]:
		add_prop("rock", point, 0)
	add_prop("sign", Vector2(1340, 785), 0)
	add_boundary(Rect2(-40, -40, WORLD_SIZE.x + 80, 60))
	add_boundary(Rect2(-40, WORLD_SIZE.y - 20, WORLD_SIZE.x + 80, 60))
	add_boundary(Rect2(-40, 0, 60, WORLD_SIZE.y))
	add_boundary(Rect2(WORLD_SIZE.x - 20, 0, 60, WORLD_SIZE.y))
	$Actors/Player/Camera.reset_smoothing()

func _physics_process(_delta: float) -> void:
	player.move_input = controls.movement()
	player.aim_input = controls.aim(player.get_global_transform_with_canvas().origin + Vector2(0, -22))

func add_prop(kind: String, at: Vector2, variant: int) -> void:
	var prop := StaticBody2D.new()
	prop.set_script(PropScene)
	prop.kind = kind
	prop.variant = variant
	prop.position = at
	$Actors.add_child(prop)

func add_boundary(rect: Rect2) -> void:
	var wall := StaticBody2D.new()
	wall.name = "Boundary"
	wall.position = rect.get_center()
	wall.collision_layer = 1
	wall.collision_mask = 2
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	var collision := CollisionShape2D.new()
	collision.shape = shape
	wall.add_child(collision)
	add_child(wall)
