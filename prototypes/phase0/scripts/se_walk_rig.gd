extends Node2D
## SE only: original texture cutouts, overlapping underpaint and two-bone IK.
## No generated replacement face, no modifications to the other seven directions.

const SOURCE: Texture2D = preload("res://assets/characters/soldier_se_rig/reference.png")
const CAPS: Texture2D = preload("res://assets/characters/soldier_se_rig/hidden_joint_caps.png")
const ORIGIN := Vector2(128, 295)
const ART_SCALE := 0.36
const STRIDE := 42.0
const STANCE := 0.58
const LIFT := 8.0
const SE := Vector2(0.70710678, 0.70710678)

var skeleton: Skeleton2D
var body: Bone2D
var head: Bone2D
var pack: Bone2D
var limbs: Dictionary = {}
var phase := 0.0
var max_stretch := 1.0
var debug_visible := false
var anchors: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO]
var takeoffs: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO]
var swing_starts: Array[float] = [STANCE,STANCE]
var first_swing: Array[bool] = [false,true]
var planted: Array[bool] = [true, true]
var feet: Array[Vector2] = [Vector2(124, 295), Vector2(167, 277)]
var _last_actor := Vector2.ZERO
var _moving := false
var _stop_time := 1.0
var _stop_feet: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO]
var idle: Sprite2D
var overlay: Node2D
var last_feet: Array[Vector2] = [Vector2.ZERO,Vector2.ZERO]

class JointOverlay:
	extends Node2D
	var rig: Node2D
	func _draw() -> void:
		for limb: Dictionary in rig.limbs.values():
			var a: Vector2 = limb.upper.get_relative_transform_to_parent(rig).origin
			var b: Vector2 = limb.lower.get_relative_transform_to_parent(rig).origin
			var c: Vector2 = limb.tip.get_relative_transform_to_parent(rig).origin
			draw_line(a,b,Color.CYAN,1,true)
			draw_line(b,c,Color.CYAN,1,true)
			for point in [a,b,c]: draw_circle(point,1.5,Color.YELLOW)
		for i in range(2):
			var u := fposmod(rig.phase+i*0.5,1)
			draw_circle(rig.last_feet[i],2.5,Color.LIME_GREEN if u < 0.58 else Color.ORANGE)

func _ready() -> void:
	position = -ORIGIN * ART_SCALE
	scale = Vector2.ONE * ART_SCALE
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	skeleton = Skeleton2D.new()
	skeleton.name = "SkeletonSE"
	add_child(skeleton)
	# Ordered siblings keep every cutout inside the player's existing y-sort group.
	limbs.near_leg = chain("RightLeg", Vector2(130,228), Vector2(122,254), Vector2(122,277), [2,3,4])
	limbs.far_leg = chain("LeftLeg", Vector2(154,224), Vector2(168,244), Vector2(163,261), [2,3,4])
	pack = bone("Backpack",Vector2(84,178),skeleton)
	var hidden_pack := cap(pack,7,Vector2(1,15),36)
	hidden_pack.scale.y *= 1.3
	mesh(pack,Vector2(84,178),[Vector2(65,128),Vector2(89,123),Vector2(99,142),Vector2(96,162),Vector2(88,169),Vector2(87,187),Vector2(80,208),Vector2(79,219),Vector2(68,205),Vector2(60,181),Vector2(57,150)])
	limbs.far_arm = chain("LeftArm",Vector2(178,181),Vector2(187,201),Vector2(185,220),[0,1,5])
	body = bone("Torso",Vector2(139,202),skeleton)
	cap(body,6,Vector2(0,-8),26)
	mesh(body,Vector2(139,202),[Vector2(116,171),Vector2(136,174),Vector2(171,164),Vector2(176,182),Vector2(175,197),Vector2(174,212),Vector2(169,231),Vector2(149,237),Vector2(121,237),Vector2(117,225),Vector2(118,211),Vector2(114,196)])
	limbs.near_arm = chain("RightArm",Vector2(112,179),Vector2(94,213),Vector2(98,235),[0,1,5])
	head = bone("HeadAndScarf",Vector2(140,166),skeleton)
	mesh(head,Vector2(140,166),[Vector2(67,34),Vector2(199,34),Vector2(201,124),Vector2(185,159),Vector2(173,173),Vector2(169,185),Vector2(149,189),Vector2(121,178),Vector2(105,164),Vector2(97,155),Vector2(86,151),Vector2(80,137),Vector2(74,126),Vector2(67,120)])
	idle = Sprite2D.new()
	idle.name = "OriginalIdle"
	idle.texture = SOURCE
	idle.centered = false
	add_child(idle)
	overlay = JointOverlay.new()
	overlay.rig = self
	overlay.visible = false
	add_child(overlay)
	skeleton.move_child(limbs.far_leg.upper,0)
	reset(Vector2.ZERO)

func bone(label: String, at: Vector2, parent: Node) -> Bone2D:
	var joint := Bone2D.new()
	joint.name = label
	joint.position = at
	joint.rest = Transform2D(0,at)
	joint.set_autocalculate_length_and_angle(false)
	joint.length = 20
	parent.add_child(joint)
	return joint

func mesh(parent: Node2D, pivot: Vector2, points: Array) -> Polygon2D:
	var polygon := Polygon2D.new()
	polygon.texture = SOURCE
	var shape := PackedVector2Array()
	var uv := PackedVector2Array()
	for point: Vector2 in points:
		shape.append(point-pivot)
		uv.append(point)
	polygon.polygon = shape
	polygon.uv = uv
	parent.add_child(polygon)
	polygon.set_meta("rest_vertices",shape)
	return polygon

func cap(parent: Node2D, cell: int, at: Vector2, diameter: float) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture = CAPS
	sprite.region_enabled = true
	var cell_size := Vector2(CAPS.get_width()/4.0,CAPS.get_height()/2.0)
	sprite.region_rect = Rect2(Vector2(cell%4,cell/4)*cell_size,cell_size)
	sprite.position = at
	sprite.scale = Vector2.ONE * diameter / (cell_size.x*0.68)
	parent.add_child(sprite)
	return sprite

func chain(label: String, a: Vector2, b: Vector2, c: Vector2, caps: Array) -> Dictionary:
	var upper := bone(label,a,skeleton)
	upper.length = a.distance_to(b)
	upper.bone_angle = (b-a).angle()
	cap(upper,caps[0],Vector2.ZERO,13)
	var lower := bone(label+"Lower",b-a,upper)
	lower.length = b.distance_to(c)
	lower.bone_angle = (c-b).angle()
	cap(lower,caps[1],Vector2.ZERO,11)
	var tip := bone(label+"End",c-b,lower)
	cap(tip,caps[2],Vector2(0,-14) if label.ends_with("Arm") else Vector2.ZERO,9)
	var outlines := {
		"RightLeg":[Vector2(116,232),Vector2(142,231),Vector2(145,241),Vector2(138,253),Vector2(136,266),Vector2(109,267),Vector2(111,254),Vector2(110,241)],
		"LeftLeg":[Vector2(145,231),Vector2(169,228),Vector2(176,236),Vector2(172,248),Vector2(169,259),Vector2(149,258),Vector2(145,249),Vector2(141,238)],
		"RightArm":[Vector2(90,171),Vector2(107,172),Vector2(117,184),Vector2(116,199),Vector2(111,215),Vector2(85,216),Vector2(82,201),Vector2(86,185)],
		"LeftArm":[Vector2(170,174),Vector2(182,176),Vector2(189,191),Vector2(190,200),Vector2(178,203),Vector2(174,193)]}
	var vertices := PackedVector2Array(outlines[label])
	var triangles := Geometry2D.triangulate_polygon(vertices)
	var dense := PackedVector2Array()
	var faces: Array[PackedInt32Array] = []
	var shared: Dictionary = {}
	for i in range(0,triangles.size(),3):
		var p := vertices[triangles[i]]
		var q := vertices[triangles[i+1]]
		var r := vertices[triangles[i+2]]
		for triangle in [[p,(p+q)*0.5,(p+r)*0.5],[(p+q)*0.5,q,(q+r)*0.5],[(p+r)*0.5,(q+r)*0.5,r],[(p+q)*0.5,(q+r)*0.5,(p+r)*0.5]]:
			var face := PackedInt32Array()
			for point: Vector2 in triangle:
				if not shared.has(point):
					shared[point] = dense.size()
					dense.append(point)
				face.append(shared[point])
			faces.append(face)
	var skin := Polygon2D.new()
	skin.name = label+"ContinuousSkin"
	skin.texture = SOURCE
	skin.uv = dense
	skin.polygon = dense
	skin.polygons = faces
	upper.add_child(skin)
	var terminal := Node2D.new()
	upper.add_child(terminal)
	var terminal_polys := {
		"RightLeg":[Vector2(108,258),Vector2(134,259),Vector2(143,278),Vector2(145,291),Vector2(134,300),Vector2(114,300),Vector2(103,288),Vector2(104,273)],
		"LeftLeg":[Vector2(144,247),Vector2(172,246),Vector2(187,258),Vector2(191,270),Vector2(181,280),Vector2(160,282),Vector2(144,270)],
		"RightArm":[Vector2(84,213),Vector2(111,212),Vector2(115,231),Vector2(103,244),Vector2(85,238),Vector2(80,225)],
		"LeftArm":[Vector2(181,201),Vector2(194,200),Vector2(199,215),Vector2(190,227),Vector2(182,225),Vector2(179,214)]}
	if label.ends_with("Leg"):
		var under := cap(terminal,4,Vector2(1,5),29)
		under.scale.y *= 0.65
	mesh(terminal,c,terminal_polys[label])
	return {"upper":upper,"lower":lower,"tip":tip,"a":a,"b":b,"c":c,"skin":skin,"source_vertices":dense,"terminal":terminal}

func solve(limb: Dictionary, hip: Vector2, target: Vector2, foot_angle: float = 0.0) -> void:
	var a: Vector2 = limb.a
	var b: Vector2 = limb.b
	var c: Vector2 = limb.c
	var length_a := a.distance_to(b)
	var length_b := b.distance_to(c)
	var distance := hip.distance_to(target)
	# Projected limbs need a little soft extension, never foot clamping/sliding.
	var stretch := maxf(1, distance/(length_a+length_b-0.05))
	max_stretch = maxf(max_stretch,stretch)
	length_a *= stretch
	length_b *= stretch
	var along := (target-hip).normalized()
	var axis := (length_a*length_a-length_b*length_b+distance*distance)/(2*maxf(distance,0.001))
	var height := sqrt(maxf(0,length_a*length_a-axis*axis))
	var side := -signf((c-a).cross(b-a))
	var knee := hip+along*axis+along.orthogonal()*height*side
	var upper_angle := (knee-hip).angle()-(b-a).angle()
	var lower_angle := (target-knee).angle()-(c-b).angle()-upper_angle
	limb.upper.position = hip
	limb.upper.length = length_a
	limb.lower.length = length_b
	limb.upper.rotation = upper_angle
	limb.lower.position = (b-a)*stretch
	limb.lower.rotation = lower_angle
	limb.tip.position = (c-b)*stretch
	limb.tip.rotation = foot_angle-upper_angle-lower_angle
	var inverse: Transform2D = limb.upper.transform.affine_inverse()
	var deformed := PackedVector2Array()
	for vertex: Vector2 in limb.source_vertices:
		var first_t := clampf((vertex-a).dot(b-a)/(b-a).length_squared(),0,1)
		var second_t := clampf((vertex-b).dot(c-b)/(c-b).length_squared(),0,1)
		var first_rest := a.lerp(b,first_t)
		var second_rest := b.lerp(c,second_t)
		var first_pose := hip.lerp(knee,first_t)+(vertex-first_rest).rotated(upper_angle)
		var second_pose := knee.lerp(target,second_t)+(vertex-second_rest).rotated(upper_angle+lower_angle)
		var blend := smoothstep(b.y-10,b.y+10,vertex.y)
		var posed := first_pose.lerp(second_pose,blend)
		deformed.append(inverse*posed)
	# Shared-vertex area constraints prevent the inside of a bent joint folding
	# texture triangles through themselves. Boots and face are never warped.
	for iteration in range(64):
		var changed := false
		for face: PackedInt32Array in limb.skin.polygons:
			var source_points: PackedVector2Array = limb.source_vertices
			var rest_area := (source_points[face[1]]-source_points[face[0]]).cross(source_points[face[2]]-source_points[face[0]])
			var sign_area := signf(rest_area)
			var p := deformed[face[0]]
			var q := deformed[face[1]]
			var r := deformed[face[2]]
			var area := (q-p).cross(r-p)*sign_area
			var minimum := absf(rest_area)*0.08
			if area >= minimum: continue
			var gradients := [Vector2(q.y-r.y,r.x-q.x)*sign_area,Vector2(r.y-p.y,p.x-r.x)*sign_area,Vector2(p.y-q.y,q.x-p.x)*sign_area]
			var denominator: float = gradients[0].length_squared()+gradients[1].length_squared()+gradients[2].length_squared()
			if denominator < 0.00001: continue
			var correction := (minimum-area)/denominator
			for k in range(3): deformed[face[k]] += gradients[k]*correction
			changed = true
		if not changed: break
	limb.skin.polygon = deformed
	limb.terminal.transform = inverse*Transform2D(foot_angle,target)

func reset(actor_position: Vector2) -> void:
	_last_actor = actor_position
	phase = 0
	for i in range(2):
		anchors[i] = actor_position+(feet[i]-ORIGIN)*ART_SCALE
		takeoffs[i] = anchors[i]
		planted[i] = true
		swing_starts[i] = STANCE
	first_swing = [false,true]
	_moving = false
	_stop_time = 1
	idle.visible = true
	skeleton.visible = false
	overlay.visible = false

func smoother(t: float) -> float:
	t = clampf(t,0,1)
	return t*t*t*(t*(t*6-15)+10)

func cycle_foot(u: float, index: int, direction: Vector2) -> Vector2:
	if u < STANCE: return feet[index]+direction*(STRIDE*0.5-STRIDE*u/STANCE)
	var t := (u-STANCE)/(1-STANCE)
	var root_travel := STRIDE*(1-STANCE)/STANCE
	var offset := -STRIDE*0.5+(STRIDE+root_travel)*smoother(t)-root_travel*t
	return feet[index]+direction*offset+Vector2.UP*pow(sin(PI*t),2)*LIFT

func sample_cycle(at_phase: float, direction: Vector2 = SE) -> void:
	phase = fposmod(at_phase,1)
	idle.visible = false
	skeleton.visible = true
	var right := cycle_foot(phase,0,direction)
	var left := cycle_foot(fposmod(phase+0.5,1),1,direction)
	apply_body(right,left,phase,direction)

func advance(actor_position: Vector2, velocity: Vector2, delta: float) -> void:
	if not _moving and velocity.length() > 0.1:
		reset(actor_position)
		_moving = true
		# Start the first support foot at its neutral mid-stance position.
		phase = STANCE*0.5
	var movement := actor_position-_last_actor
	var travel := movement.length()
	_last_actor = actor_position
	if velocity.length() < 0.1:
		if _moving:
			_stop_time = 0
			for i in range(2): _stop_feet[i] = last_feet[i]-movement/ART_SCALE
		_moving = false
		_stop_time += maxf(delta,0)
		if _stop_time >= 0.28:
			idle.visible = true
			skeleton.visible = false
			phase = 0
			return
		var rest: Array[Vector2] = []
		for i in range(2):
			var t := clampf((_stop_time-i*0.10)/0.18,0,1)
			rest.append(_stop_feet[i].lerp(feet[i],smoother(t))+Vector2.UP*sin(PI*t)*3)
		apply_body(rest[0],rest[1],phase,SE,1-smoother(_stop_time/0.28))
		return
	idle.visible = false
	skeleton.visible = true
	var direction := velocity.normalized()
	phase = fposmod(phase+travel*STANCE/(STRIDE*ART_SCALE),1)
	var positions: Array[Vector2] = []
	for i in range(2):
		var u := fposmod(phase+i*0.5,1)
		if u < STANCE:
			if not planted[i]:
				anchors[i] = actor_position+(feet[i]-ORIGIN+direction*(STRIDE*0.5-STRIDE*u/STANCE))*ART_SCALE
			planted[i] = true
			positions.append((anchors[i]-actor_position)/ART_SCALE+ORIGIN)
		else:
			if planted[i]:
				takeoffs[i] = anchors[i]
				swing_starts[i] = u if first_swing[i] else STANCE
				first_swing[i] = false
			planted[i] = false
			var t := (u-swing_starts[i])/(1-swing_starts[i])
			var remaining := (1-u)*STRIDE/STANCE
			var landing := actor_position+(feet[i]-ORIGIN+direction*(remaining+STRIDE*0.5))*ART_SCALE
			var world := takeoffs[i].lerp(landing,smoother(t))
			positions.append((world-actor_position)/ART_SCALE+ORIGIN+Vector2.UP*pow(sin(PI*t),2)*LIFT)
			anchors[i] = world
	apply_body(positions[0],positions[1],phase,direction)

func apply_body(right: Vector2, left: Vector2, u: float, direction: Vector2, strength: float = 1.0) -> void:
	last_feet = [right,left]
	var wave := cos(u*TAU)*strength
	var bob := Vector2(0,(3.5+2.5*cos(u*TAU*2))*strength)
	body.position = Vector2(139,202)+bob
	body.rotation = sin(u*TAU)*0.012*strength
	head.position = Vector2(140,166)+bob*0.75
	head.rotation = -sin(u*TAU)*0.009*strength
	pack.position = Vector2(84,178)+bob*1.1
	pack.rotation = sin(u*TAU-0.35)*0.025*strength
	solve(limbs.near_leg,limbs.near_leg.a+bob,right+Vector2(-2,-18))
	solve(limbs.far_leg,limbs.far_leg.a+bob,left+Vector2(-4,-16))
	# Right leg forward -> right arm back, left arm forward.
	solve(limbs.near_arm,limbs.near_arm.a+bob,limbs.near_arm.c+bob-direction*wave*8)
	solve(limbs.far_arm,limbs.far_arm.a+bob,limbs.far_arm.c+bob+direction*wave*8)
	overlay.visible = debug_visible
	overlay.queue_redraw()
	queue_redraw()
