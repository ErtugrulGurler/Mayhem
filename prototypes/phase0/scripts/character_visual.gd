extends Node2D
## Procedural placeholder: eight facing poses, distance-paced short steps.
## Replace this child with AnimatedSprite2D/AnimationTree later, keeping update_motion.

var facing_index := 2
var step_phase := 0.0
var movement_amount := 0.0
var bob := 0.0
var sway := 0.0
const INK := Color("263c38")

func update_motion(speed_ratio: float, direction: Vector2, delta: float) -> void:
	facing_index = posmod(roundi(direction.angle() / (PI / 4.0)), 8)
	movement_amount = move_toward(movement_amount, clampf(speed_ratio, 0, 1), delta * 12.0)
	step_phase = fmod(step_phase + delta * 15.0 * speed_ratio, TAU)
	bob = absf(sin(step_phase)) * 2.5 * movement_amount
	sway = sin(step_phase) * 0.055 * movement_amount
	queue_redraw()

func oval(center: Vector2, radii: Vector2, color: Color, border: float = 2.5) -> void:
	var points := PackedVector2Array()
	for i in range(25):
		points.append(center + Vector2(cos(i * TAU / 24.0), sin(i * TAU / 24.0)) * radii)
	draw_colored_polygon(points, color)
	if border > 0: draw_polyline(points, INK, border, true)

func _draw() -> void:
	oval(Vector2(1, 0), Vector2(24, 9), Color(0.08, 0.18, 0.14, 0.22), 0)
	var step := sin(step_phase) * 4.0 * movement_amount
	oval(Vector2(-8, -5 + step), Vector2(7, 7), Color("4b5145"))
	oval(Vector2(8, -5 - step), Vector2(7, 7), Color("4b5145"))
	draw_set_transform(Vector2(0, -bob), sway)
	# The small backpack, scarf and exposed face give this explorer its own silhouette.
	var direction := Vector2.from_angle(facing_index * PI / 4.0)
	var pack_side := -1.0 if direction.x >= -0.01 else 1.0
	oval(Vector2(pack_side * 15, -23), Vector2(8, 13), Color("b38b58"))
	oval(Vector2(0, -23), Vector2(17, 21), Color("3e9d8e"))
	oval(Vector2(-17, -22 - step * 0.4), Vector2(5, 8), Color("e9b880"))
	oval(Vector2(17, -22 + step * 0.4), Vector2(5, 8), Color("e9b880"))
	draw_colored_polygon(PackedVector2Array([Vector2(pack_side * 4, -31), Vector2(pack_side * 22, -29), Vector2(pack_side * 18, -17), Vector2(pack_side * 6, -25)]), Color("bb6047"))
	oval(Vector2(0, -33), Vector2(15, 5), Color("df8253"))
	oval(Vector2(-17, -46), Vector2(5, 6), Color("e9b880"))
	oval(Vector2(17, -46), Vector2(5, 6), Color("e9b880"))
	oval(Vector2(0, -47), Vector2(18, 18), Color("f0c38f"))
	var back := facing_index in [5, 6, 7]
	if back:
		oval(Vector2(direction.x * 3, -52), Vector2(17, 13), Color("644c3d"))
		draw_arc(Vector2(direction.x * 5, -48), 9, 0.1, 2.7, 12, Color("866447"), 2.0, true)
	else:
		var side := 1.0 if facing_index == 0 else (-1.0 if facing_index == 4 else 0.0)
		var face_shift := Vector2.from_angle(facing_index * PI / 4.0).x * 3.0
		if side == 0:
			draw_circle(Vector2(-6 + face_shift, -47), 2.2, INK)
			draw_circle(Vector2(6 + face_shift, -47), 2.2, INK)
		else:
			draw_circle(Vector2(side * 10, -47), 2.3, INK)
		oval(Vector2(face_shift + side * 10, -42), Vector2(3, 2), Color("d28c65"), 0)
		draw_arc(Vector2(face_shift, -43), 6, 0.35, 2.5, 8, INK, 1.3, true)
	# Uneven hair and a little sprout pin: no visor, spacesuit or copied costume.
	draw_colored_polygon(PackedVector2Array([Vector2(-17, -52), Vector2(-15, -63), Vector2(-6, -67), Vector2(-1, -64), Vector2(5, -69), Vector2(15, -61), Vector2(18, -54), Vector2(5, -58), Vector2(-3, -54), Vector2(-8, -58)]), Color("644c3d"))
	draw_line(Vector2(10, -64), Vector2(13, -72), INK, 2, true)
	oval(Vector2(16, -72), Vector2(5, 3), Color("b6d46a"), 1.5)
	draw_set_transform(Vector2.ZERO)
