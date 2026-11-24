extends SceneTree
const Rig = preload("res://scripts/se_walk_rig.gd")
const Visual = preload("res://scripts/character_visual.gd")
var checks := 0
var failures := 0
var max_drift := 0.0

func check(ok: bool, description: String) -> void:
	checks += 1
	if ok: print("PASS ",description)
	else:
		failures += 1
		push_error(description)

func _initialize() -> void: call_deferred("run")

func foot_source(rig: Node2D, index: int) -> Vector2:
	var limb: Dictionary = rig.limbs.near_leg if index == 0 else rig.limbs.far_leg
	return limb.terminal.get_relative_transform_to_parent(rig)*(rig.feet[index]-limb.c)

func run() -> void:
	check(FileAccess.get_file_as_bytes("res://assets/characters/soldier_se_rig/reference.png") == FileAccess.get_file_as_bytes("res://assets/mayhem_soldier/idle_SE.png"),"SE reference retains original PNG bytes")
	var rig := Rig.new()
	root.add_child(rig)
	await process_frame
	check(rig.skeleton.get_bone_count() == 15,"Real Skeleton2D contains fifteen Bone2D joints")
	check(rig.idle.visible and not rig.skeleton.visible and not rig.overlay.visible,"Idle is exact original; debug hidden")
	var triangles_ok := true
	var head_ok := true
	var retained_uv: PackedVector2Array = rig.head.get_child(0).uv
	for frame in range(128):
		rig.sample_cycle(frame/128.0)
		for limb: Dictionary in rig.limbs.values():
			var source: PackedVector2Array = limb.source_vertices
			var posed: PackedVector2Array = limb.skin.polygon
			for face: PackedInt32Array in limb.skin.polygons:
				var a := (source[face[1]]-source[face[0]]).cross(source[face[2]]-source[face[0]])
				var b := (posed[face[1]]-posed[face[0]]).cross(posed[face[2]]-posed[face[0]])
				triangles_ok = triangles_ok and a*b > 0
		head_ok = head_ok and rig.head.get_child(0).uv == retained_uv
	check(triangles_ok,"No inverted skin triangles through 128 cycle samples")
	check(head_ok,"Original head UV remains unchanged through all cycle poses")
	for phase_value in [0.0,0.5]:
		rig.sample_cycle(phase_value)
		var forward := (rig.last_feet[0]-rig.feet[0]).dot(Rig.SE)
		var right_hand: Vector2 = rig.limbs.near_arm.tip.get_relative_transform_to_parent(rig).origin
		var body_bob: Vector2 = rig.body.position-Vector2(139,202)
		var hand_forward: float = (right_hand-rig.limbs.near_arm.c-body_bob).dot(Rig.SE)
		check(forward*hand_forward < 0,"Right leg and right arm oppose at phase %.1f"%phase_value)
		check(absf((rig.last_feet[0]-rig.feet[0]).dot(Rig.SE)-(rig.last_feet[1]-rig.feet[1]).dot(Rig.SE)) > 10,"Feet have different opposing poses at phase %.1f"%phase_value)
	rig.sample_cycle(0)
	var start_vertices: PackedVector2Array = rig.limbs.near_leg.skin.polygon.duplicate()
	var start_head: Transform2D = rig.head.transform
	rig.sample_cycle(1)
	check(start_vertices == rig.limbs.near_leg.skin.polygon and rig.head.transform == start_head,"Cycle joins exactly at 1 -> 0")
	for speed in [30.0,70.0,220.0]:
		var actor := Vector2(500,500)
		rig.reset(actor)
		var previous: Array[Vector2] = [Vector2.ZERO,Vector2.ZERO]
		var previous_contact: Array[bool] = [false,false]
		var contact_frames := 0
		for frame in range(480):
			actor += Rig.SE*speed/240.0
			rig.advance(actor,Rig.SE*speed,1.0/240.0)
			for index in range(2):
				var world := actor+(foot_source(rig,index)-Rig.ORIGIN)*Rig.ART_SCALE
				if rig.planted[index] and previous_contact[index] and frame > 1:
					max_drift = maxf(max_drift,world.distance_to(previous[index]))
					contact_frames += 1
				previous[index] = world
				previous_contact[index] = rig.planted[index]
		check(contact_frames > 100,"Both feet produce measurable ground contacts at %.0f units/s"%speed)
		check(max_drift < 0.0003,"Planted feet remain world-locked at %.0f units/s"%speed)
		for i in range(80): rig.advance(actor,Vector2.ZERO,1.0/240.0)
		check(rig.idle.visible and not rig.skeleton.visible and rig.phase == 0,"Stop settles back to original pose at %.0f units/s"%speed)
	var visual := Visual.new()
	root.add_child(visual)
	for index in range(8):
		visual.update_motion(1,Vector2.from_angle(index*PI/4),0.016)
		check(visual.se_rig.visible == (index==1) and visual.sprite.visible == (index!=1),"Only SE switches renderers: direction %d"%index)
	print("METRIC maximum planted-foot drift: ",max_drift," world units")
	visual.queue_free()
	rig.queue_free()
	await process_frame
	print("SE RIG: %d checks, %d failures"%[checks,failures])
	quit(1 if failures else 0)
