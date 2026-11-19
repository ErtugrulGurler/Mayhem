class_name MayhemTerrain
extends RefCounted
static func blocked(p: Vector2) -> bool:
	if p.x < 25 or p.y < 25 or p.x > 1775 or p.y > 1175:
		return true
	return (p.x > 850 and p.x < 950 and (p.y < 460 or p.y > 740)) or Rect2(1260,150,140,180).has_point(p)
static func path(from: Vector2, to: Vector2, structures: Array, avoid_buildings: bool = true) -> PackedVector2Array:
	var grid := AStarGrid2D.new()
	grid.region = Rect2i(0,0,45,30)
	grid.cell_size = Vector2(40,40)
	grid.offset = Vector2(20,20)
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	grid.update()
	for x in range(45):
		for y in range(30):
			var p := Vector2(x*40+20,y*40+20)
			var solid := blocked(p)
			if avoid_buildings:
				for b in structures:
					if b.hp > 0 and p.distance_to(b.pos) < 38:
						solid = true
			grid.set_point_solid(Vector2i(x,y),solid)
	var start := Vector2i(clampi(int(from.x/40),0,44),clampi(int(from.y/40),0,29))
	var end := Vector2i(clampi(int(to.x/40),0,44),clampi(int(to.y/40),0,29))
	grid.set_point_solid(start,false)
	grid.set_point_solid(end,false)
	return grid.get_point_path(start,end)
static func move(from: Vector2, step: Vector2, structures: Array) -> Vector2:
	var result := from
	for part in [Vector2(step.x,0),Vector2(0,step.y)]:
		var p: Vector2 = result+part
		var collision := blocked(p)
		for b in structures:
			if b.hp > 0 and p.distance_to(b.pos) < 34:
				collision = true
		if not collision:
			result = p
	return result
