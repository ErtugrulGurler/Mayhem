extends RefCounted
## All transforms are offsets from the imported bind pose. Distances are skin
## pixels; the rig's Art node converts them to world units.
var gaits := preload("res://assets/characters/pip/run_styles.gd").new()
var rig: Node2D
var bones: Dictionary[StringName, Bone2D] = {}
var clock := 0.0
var stride := 0.0
var locomotion := 0.0
var facing := 1.0
var strike_time := -1.0
var dodge_time := -1.0
var hurt_time := -1.0
var strike_angle := 0.0
var ranged_attack := false
var down_mix := 0.0
var pose_name := "idle"

func bind_rig(node: Node2D) -> void:
	rig = node
	for bone: Bone2D in rig.get_node("Art/Skeleton2D").find_children("*", "Bone2D", true, false):
		bones[bone.name] = bone
	reset()

func reset(direction := Vector2.RIGHT, down := false) -> void:
	gaits.reset()
	clock = 0.0
	stride = 0.0
	locomotion = 0.0
	facing = -1.0 if direction.x < -0.12 else 1.0
	strike_time = -1.0
	dodge_time = -1.0
	hurt_time = -1.0
	down_mix = float(down)
	advance(0, Vector2.ZERO, Vector2.ZERO, false, false, false, down)

func action_clock(time: float, duration: float, dt: float) -> float:
	if time < 0.0 or time + dt >= duration:
		return -1.0
	return time + dt

func advance(dt: float, velocity: Vector2, aim: Vector2, attack: bool,
		dodge: bool, hit: bool, down: bool, ranged := false) -> void:
	clock = fmod(clock + dt, TAU * 100)
	strike_time = action_clock(strike_time, 0.34, dt)
	dodge_time = action_clock(dodge_time, 0.24, dt)
	hurt_time = action_clock(hurt_time, 0.25, dt)
	var speed := velocity.length()
	var heading := aim if aim.length() >= 0.15 else velocity.normalized()
	if dodge:
		heading = velocity.normalized()
	if absf(heading.x) > 0.14 and (dodge or dodge_time < 0):
		facing = signf(heading.x)
	if attack:
		strike_time = 0
		ranged_attack = ranged
		# Aim is in world axes. Convert to the rig's mirrored local axes.
		strike_angle = clampf(atan2(aim.y, absf(aim.x)), -1.05, 1.05)
	if dodge:
		dodge_time = 0
		strike_time = -1.0
	if hit:
		hurt_time = 0
	down_mix = lerpf(down_mix, float(down), 1.0-exp(-16.0*dt))
	var target_speed := clampf(speed / 185.0, 0, 1.6)
	locomotion = lerpf(locomotion, target_speed, 1.0-exp(-16.0*dt))
	var effort := smoothstep(0.0, 0.83, locomotion)
	var run := smoothstep(0.45, 1.28, locomotion)
	if locomotion > 0.005:
		stride = fmod(stride + dt * TAU * (0.65 + 1.75 * minf(locomotion, 1.5)), TAU)
	var breath := sin(clock * 3.6)
	var backpedal := -1.0 if velocity.x*facing < -speed*0.2 else 1.0
	var swing := sin(stride) * effort * backpedal
	var bounce := (1.0-cos(stride*2)) * 0.5 * effort
	var body_delta := Vector2(2.0*swing, breath*2.2*(1.0-effort)-bounce*(5.0+7.0*run))
	var squash := 0.012*breath + (0.5-bounce)*effort*0.053
	var lean := -0.015*breath + 0.037*swing - 0.04*effort*backpedal
	var neck := -0.6*lean + 0.025*sin(clock*3.6-0.55)*(1.0-effort)
	var near_arm := -swing * (0.29+0.25*run)
	var far_arm := -near_arm
	var near_elbow := -0.08 - run*0.22 - maxf(swing,0)*0.25
	var far_elbow := -0.07 - run*0.16 + minf(swing,0)*0.26
	var near_hip := swing*(0.32+0.35*run)
	var far_hip := -near_hip
	var near_knee := maxf(0, cos(stride))*effort*(0.32+0.48*run)
	var far_knee := maxf(0,-cos(stride))*effort*(0.32+0.48*run)
	var near_ankle := -near_hip*0.76 - near_knee*0.68
	var far_ankle := -far_hip*0.76 - far_knee*0.68
	pose_name = "idle" if effort < 0.08 else ("run" if run > 0.6 else "walk")

	# Coil, reach and settle are timed independently of the combat cooldown.
	if strike_time >= 0:
		pose_name = "attack"
		var prepare := smoothstep(0,0.07,strike_time)*(1.0-smoothstep(0.07,0.125,strike_time))
		var reach := smoothstep(0.065,0.135,strike_time)*(1.0-smoothstep(0.155,0.34,strike_time))
		near_arm += prepare*0.63 - reach*(0.88 if ranged_attack else 0.49)
		near_elbow -= reach*0.48
		far_arm += prepare*0.42 + reach*(strike_angle-1.36)
		far_elbow -= reach*0.17
		lean += -0.065*prepare + 0.13*reach
		neck -= 0.06*reach
		body_delta.x += -6*prepare + 11*reach
		squash += 0.036*prepare - 0.03*reach
	if dodge_time >= 0:
		pose_name = "dodge"
		var t := clampf(dodge_time/0.24,0,1)
		var tuck := sin(t*PI)
		# A quick low dive: contract, stretch along travel, then plant the boots.
		lean += 0.75*tuck
		neck -= 0.19*tuck
		body_delta += Vector2(10*tuck,7*tuck)
		squash += 0.20*tuck
		near_arm -= 1.18*tuck
		far_arm += 0.85*tuck
		near_hip -= 0.67*tuck
		far_hip += 0.76*tuck
		near_knee += 0.58*tuck
	if hurt_time >= 0:
		pose_name = "hit"
		var recoil := (1.0-smoothstep(0.025,0.25,hurt_time))*cos(hurt_time*14.0)
		lean -= 0.20*recoil
		neck -= 0.11*recoil
		body_delta += Vector2(-14,7)*recoil
		near_arm -= 0.62*recoil
		far_arm -= 0.45*recoil
		squash += 0.12*recoil
	if down_mix > 0.01:
		pose_name = "down"
		body_delta.y += 26*down_mix
		lean -= 0.22*down_mix
		near_knee += 0.62*down_mix
		far_knee += 0.58*down_mix
		squash += 0.15*down_mix

	rig.transform = Transform2D(Vector2(facing, 0), Vector2.DOWN, rig.position)
	var body: Bone2D = bones[&"body"]
	body.position = body.rest.origin + body_delta
	body.scale = Vector2(1.0+squash, 1.0-squash)
	body.rotation = lean
	bones[&"head"].rotation = neck
	bones[&"near_arm"].rotation = near_arm
	bones[&"far_arm"].rotation = far_arm
	bones[&"near_forearm"].rotation = near_elbow
	bones[&"far_forearm"].rotation = far_elbow
	bones[&"near_leg"].rotation = near_hip
	bones[&"far_leg"].rotation = far_hip
	bones[&"near_shin"].rotation = near_knee
	bones[&"far_shin"].rotation = far_knee
	bones[&"near_foot"].rotation = near_ankle
	bones[&"far_foot"].rotation = far_ankle
	bones[&"pack"].rotation = 0.027*effort*sin(stride-0.6)-0.16*lean
	bones[&"lamp"].rotation = 0.13*effort*sin(stride-0.95)+0.024*sin(clock*3.6-1.0)-0.22*lean
	bones[&"scarf_tip"].rotation = 0.13*effort*sin(stride-0.48)+0.025*breath-0.25*lean
	gaits.apply(bones, velocity, facing, dt, pose_name in ["walk", "run", "idle"])
