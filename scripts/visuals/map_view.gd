extends Node2D
var route: Curve2D

func _draw() -> void:
	draw_rect(Rect2(0, 0, 960, 540), Color("#7abb68"))
	var rng := RandomNumberGenerator.new()
	rng.seed = 81
	for i in range(110):
		var p := Vector2(rng.randf_range(5, 955), rng.randf_range(70, 425))
		draw_circle(p, rng.randf_range(2, 6), Color("#89c774"))
	var points := route.get_baked_points()
	draw_polyline(points, Color("#63964f"), 65, true)
	draw_polyline(points, Color("#b58b61"), 54, true)
	draw_polyline(points, Color("#ebce91"), 44, true)
	draw_polyline(points, Color("#f2dca9"), 30, true)
	for i in range(80):
		var p := route.sample_baked(rng.randf_range(0, route.get_baked_length()))
		p += Vector2(rng.randf_range(-12, 12), rng.randf_range(-12, 12))
		draw_circle(p, 1.5, Color("#cfaf77"))
	for p in [Vector2(40, 330), Vector2(70, 375), Vector2(385, 100), Vector2(880, 115), Vector2(916, 360), Vector2(510, 385)]:
		draw_circle(p + Vector2(5, 9), 25, Color("#639c53"))
		draw_line(p, p - Vector2(0, 32), Color("#896148"), 10)
		draw_circle(p - Vector2(0, 37), 26, Color("#398557"))
		draw_circle(p - Vector2(8, 46), 21, Color("#4c9e5b"))
		draw_circle(p - Vector2(13, 52), 10, Color("#6db766"))
	for p in [Vector2(260, 105), Vector2(550, 345), Vector2(860, 205)]:
		draw_circle(p, 11, Color("#85978a"))
		draw_circle(p - Vector2(3, 3), 7, Color("#b9c3a5"))
	for i in range(25):
		var p := Vector2(rng.randf_range(20, 940), rng.randf_range(80, 420))
		if route.get_closest_point(p).distance_to(p) > 40:
			draw_circle(p, 3, Color("#fff0ad"))
			draw_circle(p + Vector2(4, 1), 2, Color("#f5a3a5"))
	# Destination gate
	draw_style_box(gate_style(), Rect2(916, 229, 26, 46))
	draw_colored_polygon(PackedVector2Array([Vector2(907, 229), Vector2(929, 207), Vector2(950, 229)]), Color("#cc715a"))

func gate_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#f5dfb0")
	style.set_corner_radius_all(5)
	return style
