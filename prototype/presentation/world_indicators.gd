extends Node2D
## Foreground indicators share the simulation's world coordinates with the HUD.
var session: Node

func _draw() -> void:
	var state: Dictionary = session.sim.state
	var player: Dictionary = state.player
	var pos: Vector2 = player.pos
	var aim: Vector2 = player.aim
	draw_line(pos, pos + aim * 29, Color("#fff4d2"), 4)
	if player.shot_cd > 0.32 and player.slot < 0:
		draw_arc(pos, 65, aim.angle() - 0.7, aim.angle() + 0.7, 20, Color("#ffe19d"), 5)
	if player.heavy:
		draw_line(pos + Vector2(-20, -24), pos + Vector2(20, -24), Color("#795d47"), 12)
	if player.brace > 0:
		draw_arc(pos, 24, 0, TAU, 24, Color("#abcdf3"), 3)

	var active: Dictionary = session.context_target()
	if not active.is_empty():
		draw_arc(active.data.pos, 40, 0, TAU, 48, Color("#fff4af"), 3)
	if session.running and not state.tutorial.skipped and state.tutorial.step < TutorialGuide.STEPS.size():
		var target: Vector2 = TutorialGuide.task(state).target
		draw_arc(target, 46, 0, TAU, 48, Color("#bdf5e9"), 3)
	if session.running and session.build_kind != "":
		var ghost := BuildingSystem.snap(state, session.ghost)
		var valid := BuildingSystem.can_place(state, session.build_kind, ghost)
		var tint := Color(0.7, 1, 0.7, 0.5) if valid else Color(1, 0.4, 0.4, 0.5)
		draw_rect(Rect2(ghost - Vector2(28, 28), Vector2(56, 56)), tint)
