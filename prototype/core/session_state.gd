class_name MayhemState
extends RefCounted
static func fresh(character: int = 0, location: int = 0, variation: int = 0) -> Dictionary:
	var core := Vector2(620,600) if location == 0 else Vector2(1130,600)
	var sources: Array = []
	var offsets = [Vector2(-140,-100),Vector2(-80,150),Vector2(150,-70),Vector2(180,145),Vector2(-220,100)]
	var kinds = ["wood","stone","ore","rare","heavy"]
	for i in range(kinds.size()):
		sources.append({"kind":kinds[i],"pos":core+offsets[i]+Vector2(variation*25,0),"cooldown":0.0,"left":12 if kinds[i]=="rare" else -1})
	var profile: Dictionary = MayhemCatalog.CHARACTERS[character]
	return {"version":1,"world_seed":19731+variation,"attack_seed":19731+variation,"rng_state":0,"variation":variation,"location":location,
		"next_id":1,"wave":1,"phase":"prepare","phase_time":180.0,"spawn_left":0,"spawn_clock":0.0,"raid_clock":80.0,"boss_id":"","boss_phase":0,
		"core":{"pos":core,"hp":650.0,"max_hp":650.0,"repair_cd":0.0},"player":{"pos":core+Vector2(0,90),"character":character,"hp":profile.hp,
		"inventory":{},"heavy":false,"weapons":["",""],"magazines":[0,0],"slot":-1,"aim":Vector2.RIGHT,"shot_cd":0.0,"dodge_cd":0.0,
		"dodge_time":0.0,"skill_cd":0.0,"buff":0.0,"brace":0.0,"down":false,"bleed":12.0,"repair_cd":0.0,"weapon_level":1},
		"sources":sources,"structures":[],"enemies":[],"projectiles":[],"loot":[],"packets":[],"stats":SessionStatistics.fresh(),
		"tutorial":{"step":0,"skipped":false},"unranked":false,"lost":false,"elapsed":0.0,"roster":{}}
static func next_id(s: Dictionary) -> int:
	var id: int = s.next_id
	s.next_id += 1
	return id
