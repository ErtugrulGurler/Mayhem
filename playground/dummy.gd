extends Node2D
var flash := 0.0
var number := 0.0
var last_damage := 0.0
var impact := Vector2.RIGHT
func _draw() -> void:
	draw_set_transform(Vector2(0,2),0,Vector2(1,0.25))
	draw_circle(Vector2.ZERO,29,Color("#56794f"))
	draw_set_transform(Vector2.ZERO,sin(flash*32)*flash*0.52*signf(impact.x))
	draw_line(Vector2(-17,0),Vector2(0,-14),Color("#593e32"),8)
	draw_line(Vector2(17,0),Vector2(0,-14),Color("#593e32"),8)
	draw_line(Vector2.ZERO,Vector2(0,-58),Color("#997146"),9)
	draw_line(Vector2(-24,-42),Vector2(24,-42),Color("#62482e"),8)
	draw_circle(Vector2(0,-30),17,Color("#48352e"))
	draw_circle(Vector2(0,-30),14,Color("#ebb762"))
	draw_arc(Vector2(0,-30),9,0,TAU,24,Color("#ad5540"),4)
	draw_circle(Vector2(0,-30),3,Color("#ffecd0"))
	draw_circle(Vector2(0,-57),12,Color("#503b32"))
	draw_circle(Vector2(0,-57),10,Color("#dcab66"))
	draw_line(Vector2(-5,-57),Vector2(5,-57),Color("#634c3a"),3)
	if flash>0:
		for i in 6:
			var d := Vector2.from_angle(i*TAU/6.0+impact.angle())
			draw_line(Vector2(0,-30)+d*19,Vector2(0,-30)+d*(20+flash*75),Color("#ffe69c"),3)
	if number>0:
		draw_string(ThemeDB.fallback_font,Vector2(-12,-69-(0.6-number)*24),str(int(last_damage)),HORIZONTAL_ALIGNMENT_LEFT,-1,19,Color("#fff1c1"))
