class_name CombatSystem
extends RefCounted
static func hit_enemy(s: Dictionary,e: Dictionary,amount: float,source: String) -> void:
	if not s.enemies.has(e): return
	if e.get("training",false):
		e.total += amount
		e.last_hit = amount
		e.flash = 0.15
		return
	var dealt:=minf(e.hp,amount)
	e.hp-=amount
	e.flash=0.15
	SessionStatistics.hit(s.stats,source,dealt,e.hp<=0)
	if e.hp<=0:
		s.enemies.erase(e)
		var roll:=rand_value(s)
		if roll<0.08: s.loot.append({"pos":e.pos,"kind":"heal","amount":1})
		elif roll<0.12: s.loot.append({"pos":e.pos,"kind":"speed","amount":1})
		elif roll<0.25: s.loot.append({"pos":e.pos,"kind":"ore","amount":1})
static func rand_value(s: Dictionary) -> float:
	var rng:=RandomNumberGenerator.new()
	rng.seed=s.attack_seed
	if s.rng_state!=0: rng.state=s.rng_state
	var value:=rng.randf()
	s.rng_state=rng.state
	return value
static func projectile(s: Dictionary,at: Vector2,aim: Vector2,damage: float,source: String) -> void:
	s.projectiles.append({"pos":at,"dir":aim.normalized(),"damage":damage,"source":source,"life":1.3})
static func attack(s: Dictionary,aim: Vector2) -> void:
	var p: Dictionary=s.player
	if p.down or p.shot_cd>0 or aim.length()<0.15: return
	p.aim=aim.normalized()
	if p.slot<0:
		p.shot_cd=0.5
		for e in s.enemies.duplicate():
			var offset: Vector2=e.pos-p.pos
			if offset.length()<78 and offset.normalized().dot(p.aim)>0.15:
				hit_enemy(s,e,MayhemCatalog.CHARACTERS[p.character].melee,"player")
		return
	var weapon: String=p.weapons[p.slot]
	if weapon=="" or p.magazines[p.slot]<=0: return
	p.magazines[p.slot]-=1
	p.shot_cd=0.38 if weapon=="bow" else 0.8
	for angle in ([0.0] if weapon=="bow" else [-0.16,0.0,0.16]):
		projectile(s,p.pos+p.aim*20,p.aim.rotated(angle),18.0*p.weapon_level,"player")
static func dodge(s: Dictionary,movement: Vector2) -> void:
	if s.player.down or s.player.dodge_cd>0 or movement.length()<0.1: return
	s.player.dodge_cd=2.5
	s.player.dodge_time=0.22
static func skill(s: Dictionary) -> void:
	if s.player.down or s.player.skill_cd>0: return
	s.player.skill_cd=12.0
	match MayhemCatalog.CHARACTERS[s.player.character].skill:
		"shockwave":
			for e in s.enemies.duplicate():
				if e.pos.distance_to(s.player.pos)<125: hit_enemy(s,e,55,"player")
		"sprint": s.player.buff=5.0
		"brace": s.player.brace=5.0
		"bandage": s.player.hp=minf(100,s.player.hp+28)
static func tick(s: Dictionary,dt: float, barrier: Callable = Callable()) -> void:
	for b in s.structures:
		b.cooldown=maxf(0,b.cooldown-dt)
		if not b.built or not b.enabled or b.cooldown>0: continue
		if b.kind=="turret" and int(b.input.get("ammo",0))>0:
			for e in s.enemies:
				if b.pos.distance_to(e.pos)<250:
					PhysicalInventory.remove(b.input,{"ammo":1})
					projectile(s,b.pos,(e.pos-b.pos).normalized(),24.0*b.level,"team")
					b.cooldown=0.6
					break
		elif b.kind=="trap":
			for e in s.enemies.duplicate():
				if b.pos.distance_to(e.pos)<65:
					hit_enemy(s,e,20,"team")
					b.cooldown=1.0
					break
	for shot in s.projectiles.duplicate():
		shot.life-=dt
		var old: Vector2=shot.pos
		shot.pos+=shot.dir*550*dt
		var collided: bool = barrier.call(old,shot.pos) if barrier.is_valid() else MayhemTerrain.blocked(shot.pos)
		for b in s.structures:
			if b.pos.distance_to(Geometry2D.get_closest_point_to_segment(b.pos,old,shot.pos))<25 and old.distance_to(b.pos)>35: collided=true
		if not collided:
			for e in s.enemies.duplicate():
				if e.pos.distance_to(Geometry2D.get_closest_point_to_segment(e.pos,old,shot.pos))<19:
					hit_enemy(s,e,shot.damage,shot.source)
					collided=true
					break
		if collided or shot.life<=0: s.projectiles.erase(shot)
