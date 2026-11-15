class_name Projectile
extends Node2D
signal impact(at: Vector2, color: Color, radius: float)
var target: Enemy
var last_position: Vector2
var damage := 0.0
var speed := 300.0
var splash := 0.0
var color := Color.WHITE
var kind := "archer"
var lifetime := 4.0

func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
		return
	if is_instance_valid(target) and not target.dead:
		last_position = target.position
	var direction := last_position - position
	rotation = direction.angle()
	if direction.length() <= speed * delta:
		if splash > 0:
			for enemy in get_tree().get_nodes_in_group("enemies"):
				if not enemy.dead and enemy.position.distance_to(last_position) <= splash:
					enemy.take_damage(damage)
		elif is_instance_valid(target) and not target.dead:
			target.take_damage(damage)
		impact.emit(last_position, color, splash if splash > 0 else 12.0)
		queue_free()
	else:
		position += direction.normalized() * speed * delta

func _draw() -> void:
	if kind == "archer":
		draw_line(Vector2(-12, 0), Vector2(5, 0), color, 3)
		draw_colored_polygon(PackedVector2Array([Vector2(8, 0), Vector2(1, -4), Vector2(1, 4)]), Color.WHITE)
	else:
		draw_circle(Vector2.ZERO, 6 if kind == "cannon" else 5, color)
		draw_circle(Vector2(-2, -2), 2, Color.WHITE)
