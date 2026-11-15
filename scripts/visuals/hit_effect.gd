extends Node2D
var age := 0.0
var color := Color.WHITE
var radius := 15.0

func _process(delta: float) -> void:
	age += delta
	if age >= 0.35:
		queue_free()
	queue_redraw()

func _draw() -> void:
	var fade := 1.0 - age / 0.35
	var tint := Color(color, fade)
	draw_arc(Vector2.ZERO, maxf(1, radius * age / 0.35), 0, TAU, 24, tint, 3 * fade)
	for i in range(6):
		var direction := Vector2.from_angle(i * TAU / 6.0)
		draw_circle(direction * (6 + age * 65), 3 * fade, tint)
