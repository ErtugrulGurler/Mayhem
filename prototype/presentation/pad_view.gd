extends Node2D
var router: TwinStickInput
func _process(_dt: float) -> void: queue_redraw()
func _draw() -> void:
	for side in range(2):
		var center: Vector2=router.centers[side]
		draw_circle(center,69,Color(0.12,0.25,0.22,0.5))
		draw_arc(center,69,0,TAU,48,Color(0.9,0.95,0.8,0.6),2)
		var direction: Vector2=router.movement if side==0 else router.aim
		draw_circle(center+direction*42,23,Color(0.85,0.89,0.7,0.65))
		draw_string(ThemeDB.fallback_font,center+Vector2(-28,88),"HAREKET" if side==0 else "NİŞAN",HORIZONTAL_ALIGNMENT_LEFT,-1,13,Color("#fff1cd"))
