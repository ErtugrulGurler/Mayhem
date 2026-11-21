extends Node2D
## Drawn once and cached by the canvas renderer. No textures or external assets.

const WORLD_SIZE := Vector2(2400, 1600)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, WORLD_SIZE), Color("648d54"))
	var random := RandomNumberGenerator.new()
	random.seed = 80631
	for i in range(95):
		var at := Vector2(random.randf_range(25, 2375), random.randf_range(25, 1575))
		draw_circle(at, random.randf_range(28, 85), Color("6e9659") if i % 2 else Color("608650"))
	var road := Curve2D.new()
	road.add_point(Vector2(-70, 1110), Vector2.ZERO, Vector2(410, -10))
	road.add_point(Vector2(900, 940), Vector2(-230, 120), Vector2(260, -140))
	road.add_point(Vector2(1390, 700), Vector2(-190, 60), Vector2(270, -80))
	road.add_point(Vector2(2470, 470), Vector2(-400, -80), Vector2.ZERO)
	var points := road.get_baked_points()
	draw_polyline(points, Color("527548"), 156, true)
	draw_polyline(points, Color("a4915c"), 140, true)
	draw_polyline(points, Color("c6af76"), 122, true)
	draw_polyline(points, Color("d0ba81"), 82, true)
	for i in range(320):
		var at := Vector2(random.randf_range(35, 2365), random.randf_range(35, 1565))
		if road.get_closest_point(at).distance_to(at) < 88: continue
		var color := Color("98b16a") if i % 3 else Color("4d794a")
		draw_line(at + Vector2(-3, 0), at + Vector2(-5, -6), color, 2, true)
		draw_line(at, at + Vector2(1, -8), color, 2, true)
		if i % 5 == 0:
			draw_circle(at + Vector2(1, -9), 3, Color("efdc98") if i % 2 else Color("e7b4a1"))
	# Low stone border makes the limits visible as well as physical.
	for x in range(16, 2400, 36):
		for y in [12, 1588]:
			draw_style_box(border_stone(), Rect2(x - 15, y - 10, 30, 20))
	for y in range(35, 1570, 36):
		for x in [12, 2388]:
			draw_style_box(border_stone(), Rect2(x - 10, y - 15, 20, 30))

func border_stone() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("85917b")
	style.border_color = Color("4b654c")
	style.set_border_width_all(2)
	style.set_corner_radius_all(7)
	return style
