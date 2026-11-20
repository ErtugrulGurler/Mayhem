class_name ObjectGlyphs
extends RefCounted
## Original vector placeholders. Shared silhouettes, no imported assets.
static func polygon(c: Node2D, points: Array, color: Color) -> void:
	c.draw_colored_polygon(PackedVector2Array(points),color)

static func draw(c: Node2D, kind: String, at: Vector2, color: Color) -> void:
	c.draw_set_transform(at)
	var ink := Color("#30493d")
	match kind:
		"wood":
			c.draw_line(Vector2(0,14),Vector2(0,-25),Color("#79543c"),12)
			for p in [Vector2(-13,-21),Vector2(12,-25),Vector2(0,-40)]:
				c.draw_circle(p,19,ink)
				c.draw_circle(p-Vector2(1,2),16,Color("#3d975a"))
			c.draw_circle(Vector2(-6,-44),8,Color("#77c574"))
		"stone":
			polygon(c,[Vector2(-25,15),Vector2(-20,-10),Vector2(-5,-24),Vector2(17,-17),Vector2(27,13)],ink)
			polygon(c,[Vector2(-20,11),Vector2(-16,-8),Vector2(-4,-19),Vector2(14,-13),Vector2(21,10)],Color("#c1cbc3"))
			c.draw_line(Vector2(-3,-16),Vector2(8,9),Color("#899b96"),3)
		"ore":
			polygon(c,[Vector2(-26,16),Vector2(-18,-17),Vector2(-2,-12),Vector2(12,-30),Vector2(27,14)],ink)
			polygon(c,[Vector2(-21,11),Vector2(-14,-12),Vector2(1,-6),Vector2(12,-23),Vector2(21,11)],Color("#a87559"))
			for p in [Vector2(-9,-5),Vector2(10,-8),Vector2(3,7)]: c.draw_circle(p,5,Color("#e8b469"))
		"rare":
			polygon(c,[Vector2(-19,5),Vector2(-10,-26),Vector2(5,-35),Vector2(19,-11),Vector2(11,17)],ink)
			polygon(c,[Vector2(-14,4),Vector2(-7,-23),Vector2(4,-28),Vector2(13,-10),Vector2(8,11)],Color("#c9a3ed"))
			c.draw_line(Vector2(3,-25),Vector2(1,7),Color("#f0ddff"),3)
		"heavy":
			c.draw_line(Vector2(-22,5),Vector2(21,-8),ink,22)
			c.draw_line(Vector2(-21,3),Vector2(20,-10),Color("#9f7048"),16)
			c.draw_circle(Vector2(20,-10),8,Color("#e2bb82"))
		"wall":
			c.draw_style_box(box(Color("#aab1a3")),Rect2(-28,-16,56,36))
			c.draw_line(Vector2(-26,2),Vector2(26,2),ink,3)
			c.draw_line(Vector2(0,-14),Vector2(0,0),ink,3)
			c.draw_line(Vector2(-12,4),Vector2(-12,17),ink,3)
		"depot":
			c.draw_style_box(box(Color("#c19a65")),Rect2(-27,-24,54,49))
			for x in [-16,0,16]: c.draw_line(Vector2(x,-20),Vector2(x,20),Color("#926a46"),3)
			c.draw_line(Vector2(-23,18),Vector2(23,-17),Color("#e8c994"),6)
		"smelter":
			c.draw_style_box(box(Color("#949a93")),Rect2(-23,-23,46,49))
			c.draw_rect(Rect2(10,-43,13,26),ink)
			c.draw_rect(Rect2(-14,-2,28,24),ink)
			polygon(c,[Vector2(-10,18),Vector2(-5,1),Vector2(0,8),Vector2(7,-6),Vector2(12,18)],Color("#ffac58"))
			c.draw_circle(Vector2(17,-49),5,Color("#c8d0b4"))
		"ammo_bench","electric_bench":
			c.draw_style_box(box(color),Rect2(-27,-11,54,29))
			c.draw_line(Vector2(-20,17),Vector2(-20,29),ink,6)
			c.draw_line(Vector2(20,17),Vector2(20,29),ink,6)
			for x in [-14,0,14]:
				c.draw_rect(Rect2(x-4,-23,8,20),Color("#ffdf83"))
				polygon(c,[Vector2(x-4,-23),Vector2(x,-30),Vector2(x+4,-23)],Color("#f1a05e"))
			if kind=="electric_bench": bolt(c,Vector2(30,-3))
		"turret":
			c.draw_style_box(box(Color("#b7c7d0")),Rect2(-21,-20,42,44))
			for x in [-18,0,18]: c.draw_rect(Rect2(x-5,-28,10,14),ink)
			c.draw_line(Vector2(0,-9),Vector2(32,-24),ink,14)
			c.draw_circle(Vector2(32,-24),5,Color("#e0c183"))
		"clinic","medbench":
			c.draw_style_box(box(Color("#e5dccc")),Rect2(-26,-19,52,42))
			c.draw_line(Vector2(-11,1),Vector2(11,1),Color("#ca6a76"),8)
			c.draw_line(Vector2(0,-10),Vector2(0,12),Color("#ca6a76"),8)
			if kind=="clinic":
				c.draw_rect(Rect2(-30,24,60,6),Color("#ba7b74"))
				c.draw_line(Vector2(-17,-22),Vector2(-17,-37),ink,4)
				c.draw_line(Vector2(-17,-37),Vector2(9,-37),Color("#e6acb4"),9)
		"generator":
			c.draw_style_box(box(Color("#d6b967")),Rect2(-26,-23,52,46))
			c.draw_circle(Vector2.ZERO,16,ink)
			bolt(c,Vector2.ZERO)
		"cable":
			c.draw_line(Vector2(0,26),Vector2(0,-33),ink,9)
			c.draw_line(Vector2(-19,-26),Vector2(19,-26),Color("#d9bc67"),6)
			for x in [-15,15]: c.draw_circle(Vector2(x,-26),4,Color("#fff0a6"))
		"conveyor":
			c.draw_style_box(box(Color("#578d8a")),Rect2(-31,-15,62,30))
			for x in [-20,0,20]:
				c.draw_line(Vector2(x-6,-6),Vector2(x+3,0),Color("#d7e0b7"),3)
				c.draw_line(Vector2(x+3,0),Vector2(x-6,6),Color("#d7e0b7"),3)
		"trap":
			for x in [-20,-7,7,20]: polygon(c,[Vector2(x-6,15),Vector2(x,-20),Vector2(x+6,15)],Color("#d8bd90"))
			c.draw_line(Vector2(-27,17),Vector2(27,17),ink,5)
		"bowbench":
			c.draw_style_box(box(color),Rect2(-27,-7,54,24))
			c.draw_arc(Vector2(0,-13),20,-PI/2,PI/2,20,ink,4)
			c.draw_line(Vector2(0,-33),Vector2(0,7),Color("#ffedb2"),2)
		"scatterbench":
			c.draw_style_box(box(color),Rect2(-27,-7,54,24))
			c.draw_line(Vector2(-20,-19),Vector2(21,-19),ink,7)
			c.draw_line(Vector2(-17,-17),Vector2(-23,-2),Color("#a77350"),9)
		"workshop":
			c.draw_style_box(box(color),Rect2(-27,-7,54,24))
			c.draw_line(Vector2(-13,0),Vector2(12,-27),ink,9)
			c.draw_arc(Vector2(15,-30),8,0,PI*1.5,15,ink,5)
	c.draw_set_transform(Vector2.ZERO)

static func bolt(c: Node2D, at: Vector2) -> void:
	polygon(c,[at+Vector2(-2,-14),at+Vector2(-10,3),at+Vector2(-1,3),at+Vector2(-3,16),at+Vector2(10,-3),at+Vector2(2,-3)],Color("#fff4a6"))

static func box(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color=color
	style.border_color=Color("#30493d")
	style.set_border_width_all(3)
	style.set_corner_radius_all(6)
	return style
