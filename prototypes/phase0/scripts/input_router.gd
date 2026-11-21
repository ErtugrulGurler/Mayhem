extends Node
## Independent touch IDs allow move + facing simultaneously; no combat in Phase 0.

@onready var move_stick: Control = $"../HUD/Root/MoveStick"
@onready var aim_stick: Control = $"../HUD/Root/AimStick"
var owners: Dictionary = {}
var mouse_stick: Control
var mouse_aiming := false
var mouse_position := Vector2.ZERO

func movement() -> Vector2:
	if move_stick.active: return move_stick.value()
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func aim(player_screen_position: Vector2) -> Vector2:
	if aim_stick.active: return aim_stick.value()
	if mouse_aiming: return (mouse_position - player_screen_position).normalized()
	return Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if not event.pressed or event.canceled:
			if owners.has(event.index):
				owners[event.index].release()
				owners.erase(event.index)
				get_viewport().set_input_as_handled()
			return
		for stick in [move_stick, aim_stick]:
			if not stick.active and stick.contains_pointer(event.position):
				owners[event.index] = stick
				stick.set_pointer(event.position)
				get_viewport().set_input_as_handled()
				return
	elif event is InputEventScreenDrag:
		if owners.has(event.index):
			owners[event.index].set_pointer(event.position)
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton:
		mouse_position = event.position
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				for stick in [move_stick, aim_stick]:
					if not stick.active and stick.contains_pointer(event.position):
						mouse_stick = stick
						stick.set_pointer(event.position)
						break
			elif is_instance_valid(mouse_stick):
				mouse_stick.release()
				mouse_stick = null
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			mouse_aiming = event.pressed
	elif event is InputEventMouseMotion:
		mouse_position = event.position
		if is_instance_valid(mouse_stick): mouse_stick.set_pointer(event.position)

func clear() -> void:
	owners.clear()
	move_stick.release()
	aim_stick.release()
	mouse_stick = null
	mouse_aiming = false
	# OS may swallow key-up when changing apps. Do not leave a key held forever.
	for action in ["move_left", "move_right", "move_up", "move_down"]:
		Input.action_release(action)

func _notification(what: int) -> void:
	if what in [NOTIFICATION_APPLICATION_FOCUS_OUT, NOTIFICATION_APPLICATION_PAUSED]:
		if is_instance_valid(move_stick): clear()
