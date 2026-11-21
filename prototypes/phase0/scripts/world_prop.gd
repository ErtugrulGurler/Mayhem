extends StaticBody2D
## Origin is the ground contact; y-sorting and a small footprint allow walking behind.

@export_enum("tree", "rock", "sign") var kind: String = "tree"
@export var variant: int = 0
const INK := Color("304e3c")

func _ready() -> void:
	collision_layer = 1
	collision_mask = 2
	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 23 if kind == "tree" else (30 if kind == "rock" else 12)
	collision.shape = shape
	collision.position.y = -4
	add_child(collision)

func _draw() -> void:
	draw_set_transform(Vector2(0, 1), 0, Vector2(1, 0.4))
	draw_circle(Vector2.ZERO, 42 if kind == "tree" else 34, Color(0.10, 0.22, 0.13, 0.22))
	draw_set_transform(Vector2.ZERO)
	match kind:
		"tree":
			draw_line(Vector2(0, -5), Vector2(-4, -86), INK, 22)
			draw_line(Vector2(0, -5), Vector2(-4, -86), Color("947247"), 15)
			draw_line(Vector2(-3, -45), Vector2(17, -66), Color("947247"), 10)
			for item in [Vector3(-24, -81, 35), Vector3(25, -89, 34), Vector3(0, -117, 39)]:
				var at := Vector2(item.x, item.y)
				draw_circle(at, item.z + 3, INK)
				draw_circle(at, item.z, Color("3b7755") if variant % 2 else Color("497e50"))
				draw_arc(at + Vector2(-3, -5), item.z - 8, 3.4, 5.3, 16, Color("78a15a"), 6, true)
		"rock":
			var points := PackedVector2Array([Vector2(-33, -3), Vector2(-27, -30), Vector2(-8, -44), Vector2(19, -38), Vector2(34, -13), Vector2(25, 1), Vector2(-14, 6), Vector2(-33, -3)])
			draw_colored_polygon(points, Color("84958a"))
			draw_polyline(points, INK, 3, true)
			draw_colored_polygon(PackedVector2Array([Vector2(-27, -30), Vector2(-8, -44), Vector2(19, -38), Vector2(6, -20)]), Color("b7c2a7"))
			draw_line(Vector2(6, -20), Vector2(14, -4), Color("62796c"), 3, true)
		"sign":
			draw_line(Vector2.ZERO, Vector2(0, -55), INK, 13)
			draw_line(Vector2.ZERO, Vector2(0, -55), Color("b28a52"), 8)
			var board := Rect2(-32, -65, 64, 30)
			draw_rect(board, Color("e3c38a"))
			draw_rect(board, INK, false, 3)
			draw_line(Vector2(-19, -50), Vector2(19, -50), INK, 3, true)
			draw_line(Vector2(11, -56), Vector2(19, -50), INK, 3, true)
			draw_line(Vector2(11, -44), Vector2(19, -50), INK, 3, true)
