class_name Tower
extends Node2D
signal fired(tower: Tower, target: Enemy)
var kind := "archer"
var level := 1
var cooldown := 0.0
var selected := false
var aim := Vector2.RIGHT

func _ready() -> void:
	add_child(preload("res://scripts/visuals/tower_view.gd").new())

func stat(key: String) -> float:
	var base: float = GameData.TOWERS[kind][key]
	match key:
		"damage": return base * (1.0 + 0.6 * (level - 1))
		"range": return base + 14.0 * (level - 1)
		"cooldown": return base / (1.0 + 0.12 * (level - 1))
	return base

func _process(delta: float) -> void:
	cooldown -= delta
	var target: Enemy = null
	var furthest := -1.0
	for node in get_tree().get_nodes_in_group("enemies"):
		var enemy := node as Enemy
		if not enemy.dead and position.distance_to(enemy.position) <= stat("range") and enemy.distance > furthest:
			target = enemy
			furthest = enemy.distance
	if target:
		aim = (target.position - position).normalized()
		if cooldown <= 0.0:
			cooldown = stat("cooldown")
			fired.emit(self, target)
	queue_redraw()

func _draw() -> void:
	if selected:
		draw_circle(Vector2.ZERO, stat("range"), Color(0.85, 1, 0.7, 0.08))
		draw_arc(Vector2.ZERO, stat("range"), 0, TAU, 80, Color(0.85, 1, 0.7, 0.5), 2)
