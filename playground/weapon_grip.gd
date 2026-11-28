extends RefCounted
## Solve in body space so a mirrored rig still points at the exact stick angle.
static func reach(bones: Dictionary, side: String, world_target: Vector2) -> Vector2:
	var shoulder: Bone2D = bones[side+"_arm"]
	var elbow: Bone2D = bones[side+"_forearm"]
	var body := shoulder.get_parent() as Bone2D
	var to := body.to_local(world_target)-shoulder.position
	var upper := elbow.rest.origin
	var palm := Vector2(0,36)
	var a := upper.length()
	var b := palm.length()
	var distance := clampf(to.length(),absf(a-b)+0.1,a+b-0.1)
	var bend := -acos(clampf((distance*distance-a*a-b*b)/(2*a*b),-1,1))
	shoulder.rotation = wrapf(to.angle()-atan2(b*sin(bend),a+b*cos(bend))-upper.angle(),-PI,PI)
	elbow.rotation = bend+upper.angle()-palm.angle()
	return elbow.to_global(palm)

static func pose(motion, weapon: Sprite2D, slot: int, facing: Vector2, pulse: float) -> void:
	if slot==0: return
	var near := "far" if motion.skin.sector in [3,4,5] else "near"
	var torso: Bone2D = motion.bones.body
	var center := torso.to_global(Vector2(0,-72))
	var axis := facing
	var extension := 9.0
	match slot:
		1:
			extension = 13.0-3.5*pulse
			axis = facing.rotated(-0.18*pulse*signf(motion.facing))
		2:
			extension = 6.0-2.0*pulse
		3:
			var sweep := 0.38 if pulse<=0 else lerpf(0.38,-1.05,pulse)*signf(motion.facing)
			axis = facing.rotated(sweep)
			extension = 9+4*sin(pulse*PI)
	var grip := reach(motion.bones,near,center+axis*extension)
	weapon.global_position = grip
	weapon.rotation = axis.angle()
	weapon.scale = Vector2(0.52,0.52 if motion.facing>0 else -0.52)
	weapon.offset = Vector2(-8,-20)
	if slot==2:
		reach(motion.bones,"near" if near=="far" else "far",grip+axis*10.0)
