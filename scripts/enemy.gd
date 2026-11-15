class_name Enemy
extends Node2D

signal defeated(reward: int, at: Vector2)
signal escaped
var kind: String = "normal"
var health: float
var max_health: float
var speed: float
var reward: int
var distance: float = 0.0
var path: Curve2D
var dead := false

func configure(enemy_kind: String, wave: int, route: Curve2D) -> void:
	kind = enemy_kind
	path = route
	var data: Dictionary = GameData.ENEMIES[kind]
	max_health = data.health * (1.0 + (wave - 1) * 0.18)
	health = max_health
	speed = data.speed * minf(1.0 + (wave - 1) * 0.025, 1.5)
	reward = data.reward

func _ready() -> void:
	add_to_group("enemies")
	var view := preload("res://scripts/visuals/enemy_view.gd").new()
	add_child(view)
	position = path.sample_baked(0.0)

func _process(delta: float) -> void:
	if dead:
		return
	distance += speed * delta
	position = path.sample_baked(distance)
	if distance >= path.get_baked_length():
		dead = true
		escaped.emit()
		queue_free()

func take_damage(amount: float) -> void:
	if dead:
		return
	health -= amount
	if health <= 0:
		dead = true
		defeated.emit(reward, position)
		queue_free()
	else:
		$"EnemyView".flash = 1.0
