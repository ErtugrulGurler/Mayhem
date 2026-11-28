extends RefCounted
## Presentation-only gait layer, applied to the base pose before rendering.
enum { ORIGINAL, BOUNCY, CARTOON, WADDLE, FOOT_IK }
const NAMES := ["Original", "Bouncy Run", "Cartoon Run", "Waddle Run", "Foot IK Run"]
var selected := ORIGINAL
var phase := 0.0
var blend := 0.0
var previous_pose := {}
var transition := 1.0
var planted := {}
var last_velocity := Vector2.ZERO
var last_facing := 1.0
var travel_sign := 1.0
var step_count := 0

func cycle(bones: Dictionary) -> void:
	previous_pose.clear()
	for id in bones: previous_pose[id] = bones[id].transform
	transition = 0.0
	selected = (selected + 1) % NAMES.size()
	planted.clear()

func reset() -> void:
	planted.clear()
	previous_pose.clear()
	last_velocity = Vector2.ZERO
	step_count = 0
	travel_sign = 1.0
	phase = 0.0
	transition = 1.0
	blend = 0.0

func apply(b: Dictionary, velocity: Vector2, facing: float, dt: float, available: bool) -> void:
	var speed := velocity.length()
	var turn := facing != last_facing or velocity.dot(last_velocity) < 0
	if turn:
		planted.clear()
		blend *= 0.45
	last_facing = facing
	last_velocity = velocity
	var target := smoothstep(3.0, 65.0, speed) if available else 0.0
	blend = lerpf(blend, target, 1.0-exp(-18*dt))
	if selected != ORIGINAL and blend > 0.001:
		var cadence: float = [0.0, 3.5, 2.1, 4.15, 3.55][selected]
		if selected == FOOT_IK:
			cadence = clampf(speed / 51.0, 0.5, 6.2)
		else:
			cadence *= clampf(speed / 185.0, 0.42, 1.5)
		var next_phase := phase + dt * cadence
		step_count += floori(next_phase)
		phase = fposmod(next_phase, 1.0)
		var intended := -1.0 if velocity.x*facing < -0.1*speed else 1.0
		travel_sign = lerpf(travel_sign, intended, 1.0-exp(-20*dt))
		var wave := sin(TAU*phase)
		var hop := absf(wave)
		var body: Bone2D = b.body
		var offset := Vector2.ZERO
		var roll := 0.0
		var squash := 0.0
		match selected:
			BOUNCY:
				# Compress on impact, take off, then hang at the apex.
				offset.y = 8.0 - 34.0*(1.0-pow(1.0-hop,2))
				squash = 0.12*cos(phase*TAU*2)
			CARTOON:
				offset = Vector2(8, -11*hop)
				roll = 0.14
				squash = 0.045*sin(phase*TAU*2)
			WADDLE:
				offset = Vector2(9*wave, 4-5*hop)
				roll = 0.13*wave*(1.0+0.04*sin(phase*TAU*3.0))
				squash = 0.035*hop
			FOOT_IK:
				offset.y = 21.0+1.5*cos(phase*TAU*2)
		body.position = body.position.lerp(body.rest.origin+offset, blend)
		body.rotation = lerpf(body.rotation,roll,blend)
		body.scale = body.scale.lerp(Vector2(1+squash,1-squash),blend)
		b.head.rotation += blend*(-0.6*roll+0.022*sin(TAU*phase-0.4))
		b.pack.rotation += blend*(0.04*wave-roll*0.3)
		b.scarf_tip.rotation += blend*0.10*sin(phase*TAU-0.65)
		b.lamp.rotation += blend*(0.08+0.012*sin((step_count+phase)*1.7))*sin(phase*TAU-0.9)
		for side in ["near","far"]:
			var t := fposmod(phase + (0.5 if side=="far" else 0.0),1.0)
			var hip: Bone2D = b[side+"_leg"]
			var knee: Bone2D = b[side+"_shin"]
			var boot: Bone2D = b[side+"_foot"]
			var arm: Bone2D = b[side+"_arm"]
			var direction := travel_sign
			if selected == FOOT_IK:
				plant_leg(side, hip, knee, boot, body, t, velocity, cadence)
				arm.rotation = lerpf(arm.rotation,0.44*cos(t*TAU)*direction,blend)
			else:
				var angles := leg_pose(t, direction)
				hip.rotation = lerpf(hip.rotation, angles.x, blend)
				knee.rotation = lerpf(knee.rotation, angles.y, blend)
				boot.rotation = lerpf(boot.rotation, angles.z, blend)
				var pump := -angles.x*0.72
				if selected == WADDLE: pump = 0.14+0.22*sin(t*TAU-0.42)
				arm.rotation = lerpf(arm.rotation,pump,blend)
	else:
		planted.clear()
	if transition < 1.0:
		transition = minf(1.0,transition+dt/0.16)
		for id in previous_pose:
			b[id].transform = previous_pose[id].interpolate_with(b[id].transform,smoothstep(0,1,transition))
		if transition >= 1: previous_pose.clear()

func leg_pose(t: float, direction: float) -> Vector3:
	var contact := 0.48
	if selected == WADDLE: contact = 0.62
	if selected == BOUNCY: contact = 0.33
	var stance := t < contact
	var u := t/contact if stance else (t-contact)/(1.0-contact)
	var arc := sin(PI*u)
	var sweep := lerpf(-1,1,u) if stance else lerpf(1,-1,smoothstep(0,1,u))
	var hip: float
	var knee: float
	var toe: float
	match selected:
		BOUNCY:
			knee = 0.20+arc*(0.45 if stance else 1.00)
			hip = 0.37*sweep*direction-knee*0.48
			toe = -hip-knee+0.20*arc
		CARTOON:
			knee = 0.10+0.16*arc if stance else 0.1+1.32*pow(arc,1.5)*(1.25-0.7*u)
			hip = 0.91*sweep*direction-0.39*knee
			toe = -hip-knee+(0.50*arc if not stance else -0.14*arc)
		_: # long flat support and a short outward toe flick
			knee = 0.16+arc*(0.14 if stance else 0.86)
			hip = 0.24*sweep*direction-0.52*knee
			toe = -hip-knee+0.36*arc*float(not stance)
	return Vector3(hip,knee,toe)

func plant_leg(side: String, hip: Bone2D, knee: Bone2D, boot: Bone2D, body: Bone2D,
		t: float, velocity: Vector2, cadence: float) -> void:
	# Lock the ankle in world space during support. Swing back to the next
	# touchdown relative to the moving root. Clamp unreachable targets at turns.
	const SUPPORT := 0.28
	var art := body.get_parent() as Skeleton2D
	var neutral := art.to_global(body.rest.origin+hip.rest.origin+knee.rest.origin+boot.rest.origin)
	var reach := velocity*SUPPORT/(2*cadence)
	var goal: Vector2
	if t < SUPPORT:
		if not planted.has(side):
			planted[side] = neutral+reach*(1.0-2*t/SUPPORT)
		goal = planted[side]
	else:
		planted.erase(side)
		var u := (t-SUPPORT)/(1-SUPPORT)
		goal = neutral+reach*lerpf(-1,1,smoothstep(0,1,u))-Vector2(0,4.7*sin(PI*u))
	var axis := body.to_local(goal)-hip.position
	var upper := knee.rest.origin
	var lower := boot.rest.origin
	var a := upper.length()
	var c := lower.length()
	var d := clampf(axis.length(),absf(a-c)+1, a+c-0.3)
	var bend := acos(clampf((d*d-a*a-c*c)/(2*a*c),-1,1))
	var thigh := axis.angle()-atan2(c*sin(bend),a+c*cos(bend))-upper.angle()
	var shin := bend+upper.angle()-lower.angle()
	hip.rotation = lerp_angle(hip.rotation,thigh,blend)
	knee.rotation = lerp_angle(knee.rotation,shin,blend)
	boot.rotation = lerp_angle(boot.rotation,-thigh-shin-body.rotation,blend)
