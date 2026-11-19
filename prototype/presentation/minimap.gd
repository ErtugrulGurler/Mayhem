extends Control
var session: Node
func _draw() -> void:
	if session==null: return
	var s: Dictionary=session.sim.state
	draw_rect(Rect2(0,0,140,94),Color("#365a4b"))
	var scale_map:=Vector2(140.0/1800,94.0/1200)
	draw_circle(s.core.pos*scale_map,5,Color("#ffe6a6"))
	draw_circle(s.player.pos*scale_map,4,Color("#b8dffd"))
	for e in s.enemies: draw_circle(e.pos*scale_map,2,Color("#f4a0a0"))
