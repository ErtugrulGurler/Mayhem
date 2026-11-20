class_name PlayerSystem
extends RefCounted
static func tick(s: Dictionary, dt: float, movement: Vector2) -> void:
	var p: Dictionary=s.player
	var data: Dictionary=MayhemCatalog.CHARACTERS[p.character]
	for key in ["shot_cd","dodge_cd","skill_cd","dodge_time","buff","brace","repair_cd"]:
		p[key]=maxf(0,p[key]-dt)
	var speed: float=data.speed*(0.28 if p.down else 1.0)*(0.55 if p.heavy else 1.0)
	if p.buff>0: speed*=1.6
	if p.dodge_time>0: speed*=3.0
	p.pos=MayhemTerrain.move(p.pos,movement.limit_length()*speed*dt,s.structures)
	if p.down:
		p.bleed-=dt
		if p.bleed<=0: s.lost=true
	for source in s.sources: source.cooldown=maxf(0,source.cooldown-dt)
	for loot in s.loot.duplicate():
		if p.pos.distance_to(loot.pos)<32 and loot.kind in ["heal","speed"]:
			if loot.kind=="heal": p.hp=minf(data.hp,p.hp+25)
			else: p.buff=5.0
			s.loot.erase(loot)
static func gather(s: Dictionary, selected: Dictionary = {}) -> bool:
	if s.player.down: return false
	for loot in s.loot.duplicate():
		if not selected.is_empty() and selected != loot: continue
		if s.player.pos.distance_to(loot.pos)<=MayhemCatalog.REACH:
			if loot.kind=="heavy":
				if s.player.heavy: continue
				s.player.heavy=true
				s.loot.erase(loot)
				return true
			var amount:=PhysicalInventory.add(s.player.inventory,loot.kind,loot.amount,30)
			loot.amount-=amount
			if loot.amount==0: s.loot.erase(loot)
			if amount>0: return true
	for source in s.sources:
		if not selected.is_empty() and selected != source: continue
		if s.player.pos.distance_to(source.pos)>MayhemCatalog.REACH or source.cooldown>0 or source.left==0: continue
		if source.kind=="heavy":
			if s.player.heavy: continue
			s.player.heavy=true
			source.cooldown=2.0
			return true
		var available: int=2 if source.left<0 else mini(2,source.left)
		var n:=PhysicalInventory.add(s.player.inventory,source.kind,available,30)
		if n>0:
			source.cooldown=0.7
			if source.left>0: source.left-=n
			s.stats.player.gathered+=n
			return true
	return false
static func drop(s: Dictionary) -> void:
	if s.player.heavy:
		s.loot.append({"pos":s.player.pos,"kind":"heavy","amount":1})
		s.player.heavy=false
		return
	for item in s.player.inventory.keys():
		s.loot.append({"pos":s.player.pos+Vector2(20,0),"kind":item,"amount":s.player.inventory[item]})
	s.player.inventory.clear()
static func damage(s: Dictionary, amount: float) -> void:
	var p: Dictionary=s.player
	if p.down or p.dodge_time>0: return
	p.hp=maxf(0,p.hp-amount*(0.35 if p.brace>0 else 1.0))
	if p.hp==0:
		p.down=true
		p.bleed=12.0
static func heal(s: Dictionary) -> bool:
	if s.player.down: return false
	if not PhysicalInventory.remove(s.player.inventory,{"medkit":1}): return false
	s.player.hp=minf(MayhemCatalog.CHARACTERS[s.player.character].hp,s.player.hp+50)
	return true
static func clinic(s: Dictionary,b: Dictionary) -> bool:
	if not b.built or b.kind!="clinic" or b.hp<b.max_hp*0.7 or s.player.pos.distance_to(b.pos)>MayhemCatalog.REACH: return false
	if not PhysicalInventory.remove(s.player.inventory,{"wood":1}): return false
	if s.player.down:
		s.player.down=false
		s.player.bleed=12.0
	s.player.hp=minf(MayhemCatalog.CHARACTERS[s.player.character].hp,s.player.hp+35)
	return true
static func equip(s: Dictionary) -> bool:
	if s.player.down: return false
	var slot: int=maxi(0,s.player.slot)
	for kind in ["bow","scatter"]:
		if PhysicalInventory.remove(s.player.inventory,{kind:1}):
			var old: String=s.player.weapons[slot]
			if old!="":
				s.loot.append({"pos":s.player.pos,"kind":old,"amount":1})
			var rounds: int=s.player.magazines[slot]
			if rounds>0: s.loot.append({"pos":s.player.pos,"kind":"ammo","amount":rounds})
			s.player.weapons[slot]=kind
			s.player.magazines[slot]=0
			return true
	return false
static func reload_weapon(s: Dictionary) -> bool:
	var p: Dictionary=s.player
	if p.down or p.slot<0 or p.weapons[p.slot]=="": return false
	var capacity:=6 if p.weapons[p.slot]=="bow" else 4
	var n:=mini(capacity-int(p.magazines[p.slot]),int(p.inventory.get("ammo",0)))
	if n<=0: return false
	PhysicalInventory.remove(p.inventory,{"ammo":n})
	p.magazines[p.slot]+=n
	return true
static func modify(s: Dictionary,b: Dictionary) -> bool:
	if b.kind!="workshop" or not b.built or s.player.pos.distance_to(b.pos)>MayhemCatalog.REACH or s.player.weapon_level>=3: return false
	if not PhysicalInventory.remove(s.player.inventory,{"parts":1}): return false
	s.player.weapon_level+=1
	return true
