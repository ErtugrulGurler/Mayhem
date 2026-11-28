extends RefCounted
# E, SE, S, SW, W, NW, N, NE in canvas coordinates.
const HEADS = [preload("views/east.png"), preload("parts/head.png"), preload("views/south.png"),
	preload("parts/head.png"),preload("views/east.png"),preload("views/northeast.png"),
	preload("views/north.png"),preload("views/northeast.png")]
var sector := -1
var art: Node2D
var vertices := {}
var rest := {}
var order := {}

func bind(rig: Node2D, bones: Dictionary) -> void:
	art = rig.get_node("Art")
	for mesh in art.get_children():
		if mesh is Polygon2D:
			vertices[mesh.name] = mesh.polygon
			order[mesh.name] = mesh.get_index()
	for key in bones: rest[key] = bones[key].rest
	sector = -1

func orient(heading: Vector2, bones: Dictionary) -> float:
	var angle := heading.angle()
	if heading.is_zero_approx():
		if sector >= 0: return -1.0 if sector in [3,4,5] else 1.0
		angle = PI/4
	if sector < 0 or absf(angle_difference(sector*PI/4,angle)) > deg_to_rad(27):
		var next := posmod(roundi(angle/(PI/4)),8)
		if next != sector:
			sector = next
			set_view(bones)
	return -1.0 if sector in [3,4,5] else 1.0

func set_view(bones: Dictionary) -> void:
	var rear := sector >= 5
	var side := sector in [0,4]
	var frontal := sector in [2,6]
	var offsets := {}
	var widths := {}
	var spread := -20.0 if side else (9.0 if frontal else 0.0)
	for pair in [["near_leg","near_boot","near_foot",-1],["far_leg","far_boot","far_foot",1],
			["near_arm","","", -1],["far_arm","","",1]]:
		var shift := Vector2(spread*float(pair[3]),0)
		offsets[pair[0]] = shift
		if pair[1] != "": offsets[pair[1]] = shift
	offsets["satchel"] = Vector2(117 if rear else (22 if frontal else 0),6 if rear else 0)
	offsets["lamp"] = Vector2(216 if sector==6 else (45 if rear else 0),0)
	if rear: widths["satchel"] = 1.42
	widths["head"] = 0.77 if side else (0.93 if sector in [5,7] else 1.0)
	widths["coat"] = 0.74 if side else 1.0
	widths["collar"] = widths.coat
	for key in ["near_leg","far_leg","near_arm","far_arm","pack","lamp"]:
		var t: Transform2D = rest[key]
		if key == "pack": t.origin += offsets.satchel
		elif key == "lamp": t.origin += offsets.lamp-offsets.satchel
		else: t.origin += Vector2(offsets.get(key,Vector2.ZERO))
		bones[key].rest = t
		bones[key].position = t.origin
	for key in vertices:
		var mesh: Polygon2D = art.get_node(NodePath(key))
		var points: PackedVector2Array = vertices[key].duplicate()
		for i in points.size():
			points[i].x *= float(widths.get(key,1.0))
			points[i] += Vector2(offsets.get(key,Vector2.ZERO))
		mesh.polygon = points
		# Child order is local to Pip; depth relative to trees remains foot-based.
		art.move_child(mesh,order[key])
	var head: Polygon2D = art.get_node("head")
	head.texture = HEADS[sector]
	var size := head.texture.get_size()
	head.uv = PackedVector2Array([Vector2.ZERO,Vector2(size.x,0),Vector2(0,size.y),size])
	if rear:
		art.move_child(art.get_node("satchel"),art.get_child_count()-2)
		art.move_child(art.get_node("lamp"),art.get_child_count()-2)
