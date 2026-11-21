extends CharacterBody2D
## Only movement and facing live here; the replaceable Visual owns all artwork.

@export var move_speed: float = 220.0
@export var acceleration: float = 1400.0
@export var braking: float = 1800.0
var move_input := Vector2.ZERO
var aim_input := Vector2.ZERO
var facing_direction := Vector2.DOWN
@onready var visual: Node2D = $Visual

func _physics_process(delta: float) -> void:
	var desired := move_input.limit_length() * move_speed
	velocity = velocity.move_toward(desired, (braking if desired.is_zero_approx() else acceleration) * delta)
	move_and_slide()
	if not aim_input.is_zero_approx():
		facing_direction = aim_input.normalized()
	elif not move_input.is_zero_approx():
		facing_direction = move_input.normalized()
	visual.update_motion(get_real_velocity().length() / move_speed, facing_direction, delta)
	queue_redraw()

func _draw() -> void:
	if not aim_input.is_zero_approx():
		var tip := Vector2(0, -22) + aim_input.normalized() * 46.0
		draw_arc(tip, 7, 0, TAU, 16, Color("fff0c5"), 2.0, true)
		draw_circle(tip, 2.0, Color("fff0c5"))
