class_name LogisticsSystem
extends RefCounted
static func connect_nearest(s: Dictionary, belt: Dictionary) -> bool:
	var sources: Array = []
	var sinks: Array = []
	for b in s.structures:
		if b.built and b.id!=belt.id and b.pos.distance_to(belt.pos)<=180:
			if MayhemCatalog.RECIPES.has(b.kind): sources.append(b)
			if b.kind=="turret" or MayhemCatalog.RECIPES.has(b.kind) or b.kind=="depot": sinks.append(b)
	sources.sort_custom(func(a,b):return a.id<b.id)
	for source in sources:
		for sink in sinks:
			if source.id!=sink.id and segment_clear(source.pos,sink.pos):
				belt.links=[source.id,sink.id]
				return true
	return false
static func segment_clear(a: Vector2, b: Vector2) -> bool:
	for i in range(21):
		if MayhemTerrain.blocked(a.lerp(b,i/20.0)): return false
	return true
static func tick(s: Dictionary, dt: float) -> void:
	var by_id := {}
	for b in s.structures: by_id[b.id]=b
	for belt in s.structures:
		if belt.kind!="conveyor" or not belt.built or not belt.enabled or s.wave<11 or belt.links.size()!=2: continue
		if not by_id.has(belt.links[0]) or not by_id.has(belt.links[1]): continue
		belt.flow-=dt
		if belt.flow>0: continue
		belt.flow=0.6
		var source: Dictionary = by_id[belt.links[0]]
		var sink: Dictionary = by_id[belt.links[1]]
		for item in source.output.keys():
			if accepts(sink,item):
				if PhysicalInventory.remove(source.output,{item:1}):
					s.packets.append({"belt":belt.id,"target":sink.id,"kind":item,"amount":1,"from":source.pos,"to":sink.pos,"pos":source.pos,"progress":0.0})
					break
	for packet in s.packets.duplicate():
		if not by_id.has(packet.belt) or not by_id.has(packet.target):
			s.loot.append({"pos":packet.pos,"kind":packet.kind,"amount":packet.amount})
			s.packets.erase(packet)
			continue
		packet.progress=minf(1,packet.progress+dt*100/maxf(1,packet.from.distance_to(packet.to)))
		packet.pos=packet.from.lerp(packet.to,packet.progress)
		if packet.progress>=1:
			var sink: Dictionary=by_id[packet.target]
			var stock: Dictionary=sink.stock if sink.kind=="depot" else sink.input
			if PhysicalInventory.add(stock,packet.kind,1,60 if sink.kind=="depot" else 24)==1: s.packets.erase(packet)
static func accepts(b: Dictionary,item: String) -> bool:
	if b.kind=="depot": return true
	if b.kind=="turret": return item=="ammo"
	return MayhemCatalog.RECIPES.has(b.kind) and MayhemCatalog.RECIPES[b.kind].input.has(item)
