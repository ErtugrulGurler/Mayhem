extends RefCounted
var phase := 0.0
var blend := 0.0
var travel_sign := 1.0
var step_count := 0
func reset() -> void:
	phase = 0.0
	blend = 0.0
	step_count = 0
	travel_sign = 1.0

func apply(b: Dictionary, velocity: Vector2, facing: float, dt: float, available: bool) -> void:
	var speed := velocity.length()
	var target := smoothstep(3.0, 65.0, speed) if available else 0.0
	blend = lerpf(blend, target, 1.0-exp(-18*dt))
	if blend > 0.001:
		var cadence := 2.1*clampf(speed/185.0,0.42,1.5)
		var next_phase := phase + dt * cadence
		step_count += floori(next_phase)
		phase = fposmod(next_phase, 1.0)
		var intended := -1.0 if velocity.x*facing < -0.1*speed else 1.0
		travel_sign = lerpf(travel_sign, intended, 1.0-exp(-20*dt))
		var wave := sin(TAU*phase)
		var hop := absf(wave)
		var body: Bone2D = b.body
		var offset := Vector2(8,-11*hop)
		var roll := 0.14
		var squash := 0.045*sin(phase*TAU*2)
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
			var stance := t < 0.48
			var u := t/0.48 if stance else (t-0.48)/0.52
			var arc := sin(PI*u)
			var sweep := lerpf(-1,1,u) if stance else lerpf(1,-1,smoothstep(0,1,u))
			var bend := 0.10+0.16*arc if stance else 0.1+1.32*pow(arc,1.5)*(1.25-0.7*u)
			var thigh := 0.91*sweep*direction-0.39*bend
			hip.rotation = lerpf(hip.rotation,thigh,blend)
			knee.rotation = lerpf(knee.rotation,bend,blend)
			boot.rotation = lerpf(boot.rotation,-thigh-bend+(0.5*arc if not stance else -0.14*arc),blend)
			arm.rotation = lerpf(arm.rotation,-thigh*0.72,blend)
