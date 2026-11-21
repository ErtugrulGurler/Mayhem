extends Control
## Rendering and dead-zone conversion only. InputRouter owns pointer lifetimes.

@export var caption := "HAREKET"
var displacement := Vector2.ZERO
var active := false
const DEAD_ZONE := 0.14

func radius() -> float:
	return minf(size.x, size.y) * 0.39

func center() -> Vector2:
	return global_position + size * 0.5

func contains_pointer(point: Vector2) -> bool:
	return point.distance_to(center()) <= radius() + 12.0

func set_pointer(point: Vector2) -> void:
	active = true
	displacement = ((point - center()) / radius()).limit_length()
	queue_redraw()

func release() -> void:
	active = false
	displacement = Vector2.ZERO
	queue_redraw()

func value() -> Vector2:
	var strength := displacement.length()
	if strength <= DEAD_ZONE: return Vector2.ZERO
	return displacement.normalized() * ((strength - DEAD_ZONE) / (1.0 - DEAD_ZONE))

func _draw() -> void:
	var origin := size * 0.5
	var outer := radius()
	draw_circle(origin + Vector2(0, 4), outer + 4, Color(0.04, 0.12, 0.10, 0.18))
	draw_circle(origin, outer, Color(0.07, 0.19, 0.17, 0.58))
	draw_arc(origin, outer, 0, TAU, 48, Color(0.94, 0.89, 0.70, 0.8), 2.5, true)
	for direction in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		draw_line(origin + direction * (outer - 12), origin + direction * (outer - 6), Color("e3d9b1"), 2.0, true)
	var knob := origin + displacement * outer * 0.65
	draw_circle(knob + Vector2(0, 3), 24, Color(0.06, 0.12, 0.10, 0.3))
	draw_circle(knob, 24, Color("efdba8") if active else Color("c4c2a0"))
	draw_arc(knob, 24, 0, TAU, 32, Color("fff0c5"), 2.0, true)
