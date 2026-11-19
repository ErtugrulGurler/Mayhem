class_name EnemySystem
extends RefCounted
static func spawn(s: Dictionary,kind: String,at: Vector2,main: bool = true) -> Dictionary:
	var hp: float=38.0+s.wave*3.0
	if kind=="siege": hp*=2.2
	if kind=="boss": hp*=9
	var e: Dictionary={"id":MayhemState.next_id(s),"kind":kind,"pos":at,"hp":hp,"max_hp":hp,"main":main,"cd":0.0,"flash":0.0,"nav":0.0,"path":PackedVector2Array()}
	s.enemies.append(e)
	return e
static func target(s: Dictionary,e: Dictionary) -> Dictionary:
	if e.pos.distance_to(s.player.pos)<100 and not s.player.down: return s.player
	if e.kind=="saboteur":
		for b in s.structures:
			if b.kind in ["smelter","ammo_bench","depot","conveyor","generator","cable","electric_bench"] and e.pos.distance_to(b.pos)<260:
				return b
	return s.core
static func tick(s: Dictionary,dt: float) -> void:
	for e in s.enemies.duplicate():
		e.cd=maxf(0,e.cd-dt)
		e.flash=maxf(0,e.flash-dt)
		e.nav-=dt
		var goal:=target(s,e)
		var distance: float=e.pos.distance_to(goal.pos)
		if distance<48:
			strike(s,e,goal)
			continue
		if e.nav<=0:
			e.path=MayhemTerrain.path(e.pos,goal.pos,s.structures,e.kind!="siege")
			if e.path.is_empty(): e.path=MayhemTerrain.path(e.pos,goal.pos,[],false)
			e.nav=1.0
		var next: Vector2=goal.pos
		while e.path.size()>0 and e.pos.distance_to(e.path[0])<22: e.path.remove_at(0)
		if e.path.size()>0: next=e.path[0]
		var speed:=49.0 if e.kind!="runner" else 83.0
		if e.kind=="boss": speed=35.0
		var step: Vector2=(next-e.pos).normalized()*speed*dt
		var blocked:=false
		for b in s.structures.duplicate():
			if (e.pos+step).distance_to(b.pos)<47:
				strike(s,e,b)
				blocked=true
				break
		if not blocked and not MayhemTerrain.blocked(e.pos+step): e.pos+=step
static func strike(s: Dictionary,e: Dictionary,goal: Dictionary) -> void:
	if e.cd>0: return
	e.cd=0.8
	var amount:=8.0 if e.kind!="siege" else 24.0
	if e.kind=="boss": amount=28.0
	if goal==s.player: PlayerSystem.damage(s,amount)
	elif goal==s.core:
		s.core.hp=maxf(0,s.core.hp-amount)
		if s.core.hp<=0: s.lost=true
	else: BuildingSystem.damage(s,goal,amount)
