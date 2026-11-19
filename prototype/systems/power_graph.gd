class_name PowerGraph
extends RefCounted
## Cables are destructible world structures, with explicit endpoint IDs.
static func connect_nearest(s: Dictionary, cable: Dictionary) -> bool:
	var candidates: Array = []
	for b in s.structures:
		if b.id!=cable.id and b.built and b.pos.distance_to(cable.pos)<=220 and b.kind in ["generator","electric_bench","cable"]:
			candidates.append(b)
	candidates.sort_custom(func(a,b): return a.pos.distance_to(cable.pos)<b.pos.distance_to(cable.pos))
	if candidates.size()<2: return false
	for b in candidates.slice(0,2):
		if LogisticsSystem.segment_clear(cable.pos,b.pos):
			cable.links.append(b.id)
	return cable.links.size()==2
static func tick(s: Dictionary) -> void:
	var by_id := {}
	for b in s.structures:
		b.powered=false
		if b.built and b.hp>0 and b.enabled: by_id[b.id]=b
	var seen := {}
	for id in by_id:
		if seen.has(id): continue
		var queue: Array = [id]
		var component: Array = []
		while not queue.is_empty():
			var current = queue.pop_back()
			if seen.has(current): continue
			seen[current]=true
			component.append(current)
			var b: Dictionary = by_id[current]
			if b.kind=="cable":
				for linked in b.links:
					if by_id.has(linked): queue.append(linked)
			for other in by_id:
				if by_id[other].kind=="cable" and by_id[other].links.has(current): queue.append(other)
		var supply := 0.0
		var demand := 0.0
		for key in component:
			var b: Dictionary = by_id[key]
			if b.kind=="generator": supply+=4.0*b.hp/b.max_hp
			if b.kind=="electric_bench": demand+=3.0
		for key in component:
			by_id[key].powered = supply>0 and supply>=demand
