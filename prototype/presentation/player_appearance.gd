extends Node2D
## Renders the selected profile. Pose history belongs to this view, never the save.
const PipRig := preload("res://assets/characters/pip/pip_rig.tscn")
const PipMotion := preload("res://assets/characters/pip/pip_motion.gd")

var pip: Node2D
var motion: PipMotion
var profile_index := -1
var tracked_player: Dictionary
var previous_position := Vector2.ZERO
var previous_hp := 0.0
var previous_shot_cd := 0.0
var was_dodging := false
var body_color := Color.WHITE
var down := false

func present(player: Dictionary) -> void:
	position = player.pos
	if not is_same(player, tracked_player) or profile_index != player.character:
		tracked_player = player
		profile_index = player.character
		var uses_pip: bool = player.character == MayhemCatalog.PIP_PROFILE
		if uses_pip:
			if not is_instance_valid(pip):
				pip = PipRig.instantiate()
				pip.position = Vector2(0, 15)
				add_child(pip)
				motion = PipMotion.new()
				motion.bind_rig(pip)
			motion.reset(player.aim, player.down)
		if is_instance_valid(pip):
			pip.visible = uses_pip
		remember(player)
		queue_redraw()
	var color := Color(MayhemCatalog.CHARACTERS[player.character].color)
	if body_color != color or down != player.down:
		body_color = color
		down = player.down
		queue_redraw()

## Called once after a simulation step. HUD refreshes can happen while paused.
func advance(player: Dictionary, dt: float, aim_input: Vector2) -> void:
	present(player)
	if not is_instance_valid(pip) or not pip.visible or dt <= 0.0:
		return
	var velocity := (position - previous_position) / dt
	var attack_started: bool = player.shot_cd > maxf(0.0, previous_shot_cd - dt) + 0.0001
	var dodge_started: bool = player.dodge_time > 0.0 and not was_dodging
	motion.advance(dt, velocity, aim_input, attack_started, dodge_started,
			player.hp < previous_hp, player.down, player.slot >= 0)
	remember(player)

func remember(player: Dictionary) -> void:
	previous_position = player.pos
	previous_hp = player.hp
	previous_shot_cd = player.shot_cd
	was_dodging = player.dodge_time > 0.0

func _draw() -> void:
	if is_instance_valid(pip) and pip.visible:
		draw_set_transform(Vector2(0, 13), 0.0, Vector2(1, 0.29))
		draw_circle(Vector2.ZERO, 16, Color(0.18, 0.29, 0.2, 0.32))
		return
	draw_circle(Vector2(0, 8), 20, Color("#537e55"))
	draw_colored_polygon(PackedVector2Array([
		Vector2(-13, 2), Vector2(-20, 26), Vector2(18, 24), Vector2(12, 0)
	]), body_color.darkened(0.25))
	draw_circle(Vector2.ZERO, 19, Color("#364b50"))
	draw_circle(Vector2.ZERO, 16, Color("#aa8881") if down else body_color)
	draw_circle(Vector2(-5, -3), 3, Color("#fff5db"))
	draw_circle(Vector2(5, -3), 3, Color("#fff5db"))
	draw_arc(Vector2(0, -2), 18, PI, TAU, 20, Color("#e3e8d4"), 6)
