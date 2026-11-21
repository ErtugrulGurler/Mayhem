extends Control
var location:=0
var variation:=0
func _ready() -> void:
	custom_minimum_size=Vector2(0,110)
	mouse_filter=Control.MOUSE_FILTER_IGNORE
func _draw() -> void:
	draw_style_box(MenuTheme.box(Color("#64844b")),Rect2(Vector2.ZERO,size))
	draw_rect(Rect2(size.x*0.48,0,size.x*0.07,size.y),Color("#629a9a"))
	draw_rect(Rect2(size.x*0.47,size.y*0.38,size.x*0.09,size.y*0.3),Color("#c1aa70"))
	for i in range(10):
		draw_circle(Vector2(30+i*size.x/11,25+(i%3)*24),8,Color("#386446"))
	var pos:=Vector2(size.x*(0.32 if location==0 else 0.7),size.y*0.58)
	draw_circle(pos,16,Color("#fff1bb")); draw_circle(pos,10,Color("#e4ab5e"))
	draw_circle(pos+Vector2(-45+variation*12,22),5,Color("#c6d7bd"))
