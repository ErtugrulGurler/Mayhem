extends Node2D
var router: TwinStickInput
var session: Node
func _process(_dt: float) -> void: queue_redraw()
func _draw() -> void:
	if session!=null and not session.running: return
	for side in range(2):
		var center: Vector2=router.centers[side]
		draw_circle(center,69,Color(0.10,0.22,0.2,0.6))
		draw_arc(center,69,0,TAU,48,Color(0.9,0.95,0.8,0.6),2)
		var direction: Vector2=router.movement if side==0 else router.aim
		draw_circle(center+direction*42,23,Color(0.85,0.89,0.7,0.65))
		draw_string(ThemeDB.fallback_font,center+Vector2(-28,85),"HAREKET" if side==0 else "NİŞAN",HORIZONTAL_ALIGNMENT_LEFT,-1,13,Color("#fff1cd"))
	if session==null or session.hud.open_panel!="" or session.sim.state.tutorial.skipped or session.sim.state.tutorial.step>=TutorialGuide.STEPS.size(): return
	var state: Dictionary=session.sim.state
	var task: Dictionary=TutorialGuide.task(state)
	var screen: Vector2=session.get_canvas_transform()*task.target
	var viewport: Vector2=get_viewport_rect().size
	var at: Vector2=screen.clamp(Vector2(180,205),viewport-Vector2(180,190))
	var dir: Vector2=(screen-at).normalized()
	if dir.length()<0.1: dir=Vector2.DOWN
	draw_circle(at,17,Color("#254e47"))
	draw_line(at-dir*8,at+dir*9,Color("#c6ffed"),4)
	ObjectGlyphs.polygon(self,[at+dir*13,at+dir*3+dir.orthogonal()*7,at+dir*3-dir.orthogonal()*7],Color("#c6ffed"))
	var meters: float=state.player.pos.distance_to(task.target)
	var caption: String = "Odun" if state.tutorial.step==0 else ("Taş" if state.tutorial.step==1 else "Görev")
	draw_string(ThemeDB.fallback_font,at+Vector2(-35,34),"%s · %.0f" % [caption,meters/20],HORIZONTAL_ALIGNMENT_LEFT,-1,13,Color("#fff5cf"))
