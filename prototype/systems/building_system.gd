class_name BuildingSystem
extends RefCounted
static func snap(s: Dictionary, p: Vector2) -> Vector2:
	var result := p
	for b in s.structures:
		if p.distance_to(b.pos) < 105:
			if absf(p.x-b.pos.x)<13: result.x=b.pos.x
			if absf(p.y-b.pos.y)<13: result.y=b.pos.y
	return result
static func can_place(s: Dictionary, kind: String, p: Vector2) -> bool:
	if not MayhemCatalog.BUILDINGS.has(kind) or s.wave < MayhemCatalog.BUILDINGS[kind].wave or MayhemTerrain.blocked(p):
		return false
	for offset in [Vector2(28,28),Vector2(-28,28),Vector2(28,-28),Vector2(-28,-28)]:
		if MayhemTerrain.blocked(p+offset): return false
	if p.distance_to(s.player.pos)<49 or p.distance_to(s.core.pos)<65: return false
	for b in s.structures:
		if p.distance_to(b.pos)<60: return false
	for enemy in s.enemies:
		if p.distance_to(enemy.pos)<52: return false
	for source in s.sources:
		if p.distance_to(source.pos)<45: return false
	return true
static func place(s: Dictionary, kind: String, p: Vector2) -> Dictionary:
	p = snap(s,p)
	if not can_place(s,kind,p): return {}
	var b := MayhemCatalog.building(kind,p,MayhemState.next_id(s))
	s.structures.append(b)
	return b
static func deliver(s: Dictionary, b: Dictionary) -> int:
	if s.player.pos.distance_to(b.pos)>MayhemCatalog.REACH or b.built: return 0
	var moved := 0
	var cost: Dictionary = MayhemCatalog.BUILDINGS[b.kind].cost
	for item in cost:
		var need: int = cost[item]-b.delivered.get(item,0)
		moved += PhysicalInventory.transfer(s.player.inventory,b.delivered,item,maxi(0,need),999)
	return moved
static func tick(s: Dictionary, dt: float) -> void:
	for b in s.structures:
		if not b.built and PhysicalInventory.has(b.delivered,MayhemCatalog.BUILDINGS[b.kind].cost):
			b.progress += dt
			if b.progress >= MayhemCatalog.BUILDINGS[b.kind].time:
				b.built = true
static func repair(s: Dictionary, b: Dictionary) -> bool:
	if s.player.down or s.player.pos.distance_to(b.pos)>MayhemCatalog.REACH or b.hp>=b.max_hp or s.player.repair_cd>0: return false
	if not PhysicalInventory.remove(s.player.inventory,{"wood":1}): return false
	var amount := minf(30,b.max_hp-b.hp)
	b.hp += amount
	s.stats.player.repair += int(amount)
	s.player.repair_cd=0.65
	return true
static func dismantle(s: Dictionary, b: Dictionary) -> void:
	if s.player.pos.distance_to(b.pos)>MayhemCatalog.REACH: return
	var refund: Dictionary = b.delivered.duplicate(true)
	if b.built: refund=MayhemCatalog.BUILDINGS[b.kind].cost
	for item in refund:
		var n := int(refund[item]*0.5)
		if n>0: s.loot.append({"pos":b.pos+Vector2(25,0),"kind":item,"amount":n})
	for stock in [b.input,b.output,b.stock]:
		for item in stock:
			s.loot.append({"pos":b.pos,"kind":item,"amount":stock[item]})
	s.structures.erase(b)
static func damage(s: Dictionary, b: Dictionary, amount: float) -> void:
	b.hp=maxf(0,b.hp-amount)
	if b.hp<=0:
		for stock in [b.stock,b.input,b.output]:
			for item in stock:
				var keep := int(stock[item]*0.5)
				if keep>0: s.loot.append({"pos":b.pos,"kind":item,"amount":keep})
		s.structures.erase(b)
