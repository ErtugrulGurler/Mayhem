extends Node2D

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var tower := get_parent() as Tower
	var color: Color = GameData.TOWERS[tower.kind].color
	draw_circle(Vector2(0, 9), 27, Color(0.1, 0.2, 0.1, 0.2))
	draw_style_box(base_style(), Rect2(-23, -17, 46, 40))
	draw_line(Vector2(-20, 7), Vector2(20, 7), Color("#8c7d72"), 2)
	match tower.kind:
		"archer":
			draw_colored_polygon(PackedVector2Array([Vector2(-30, -17), Vector2(0, -42), Vector2(30, -17)]), Color("#459567"))
			draw_line(Vector2(0, -20), Vector2(0, -20) + tower.aim * 25, color, 5)
		"mage":
			draw_colored_polygon(PackedVector2Array([Vector2(-26, -17), Vector2(0, -46), Vector2(26, -17)]), Color("#7956a6"))
			draw_circle(Vector2(0, -30), 9, Color("#d3b7ff"))
			draw_circle(Vector2(-2, -33), 3, Color.WHITE)
		"cannon":
			draw_circle(Vector2(0, -16), 17, Color("#655b68"))
			draw_line(Vector2(0, -16), Vector2(0, -16) + tower.aim * 29, Color("#393c50"), 15)
			draw_circle(Vector2(0, -16) + tower.aim * 27, 5, Color("#f8b870"))
	for i in range(tower.level):
		draw_circle(Vector2(-8 + i * 8, 16), 2.5, Color("#fff2a3"))

func base_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#d9c5a0")
	style.border_color = Color("#65595b")
	style.set_border_width_all(3)
	style.set_corner_radius_all(8)
	return style
