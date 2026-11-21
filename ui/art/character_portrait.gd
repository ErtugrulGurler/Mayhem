extends Control
var character:=0
func _ready() -> void: mouse_filter=Control.MOUSE_FILTER_IGNORE
func _draw() -> void:
	var color:=Color(MayhemCatalog.CHARACTERS[character].color)
	draw_set_transform(Vector2(size.x/2,size.y/2+7))
	draw_circle(Vector2(0,29),25,Color(0.1,0.2,0.12,0.25))
	draw_colored_polygon(PackedVector2Array([Vector2(-15,0),Vector2(-26,30),Vector2(26,30),Vector2(15,0)]),color.darkened(0.3))
	draw_circle(Vector2(0,-8),22,Color("#f3c78d"))
	draw_circle(Vector2(-7,-10),3,Color("#284335")); draw_circle(Vector2(7,-10),3,Color("#284335"))
	match character:
		0:
			draw_arc(Vector2(0,-10),23,PI,TAU,20,color,9)
			draw_rect(Rect2(-5,-42,10,15),Color("#e6e3b7"))
		1:
			draw_colored_polygon(PackedVector2Array([Vector2(-27,-21),Vector2(22,-21),Vector2(10,-41)]),color)
			draw_line(Vector2(21,9),Vector2(30,-26),Color("#8a6942"),4)
		2:
			draw_rect(Rect2(-25,-33,50,15),color)
			for x in [-9,9]: draw_circle(Vector2(x,-25),7,Color("#3a5145"))
		3:
			draw_rect(Rect2(-22,-34,44,15),color)
			draw_line(Vector2(-5,-29),Vector2(5,-29),Color("#fff0cb"),4)
			draw_line(Vector2(0,-34),Vector2(0,-24),Color("#fff0cb"),4)
	draw_set_transform(Vector2.ZERO)
