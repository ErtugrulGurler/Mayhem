extends Node2D
## Visual for the four existing roster profiles. The origin follows the player's
## simulation position. World-space targeting and status cues are drawn separately.

var body_color := Color.WHITE
var down := false

func present(player: Dictionary) -> void:
	position = player.pos
	var color := Color(MayhemCatalog.CHARACTERS[player.character].color)
	if body_color != color or down != player.down:
		body_color = color
		down = player.down
		queue_redraw()

func _draw() -> void:
	draw_circle(Vector2(0, 8), 20, Color("#537e55"))
	draw_colored_polygon(PackedVector2Array([
		Vector2(-13, 2), Vector2(-20, 26), Vector2(18, 24), Vector2(12, 0)
	]), body_color.darkened(0.25))
	draw_circle(Vector2.ZERO, 19, Color("#364b50"))
	draw_circle(Vector2.ZERO, 16, Color("#aa8881") if down else body_color)
	draw_circle(Vector2(-5, -3), 3, Color("#fff5db"))
	draw_circle(Vector2(5, -3), 3, Color("#fff5db"))
	draw_arc(Vector2(0, -2), 18, PI, TAU, 20, Color("#e3e8d4"), 6)
