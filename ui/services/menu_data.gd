class_name MenuData
extends RefCounted
static func suspend(path: String="user://suspend.bin") -> Dictionary:
	var s:=MayhemSave.read(path)
	if s.is_empty() or s.get("lost",true): return {}
	var sample:=MayhemState.fresh()
	sample.erase("tutorial")
	if not shape(s,sample): return {}
	# Validate nested data before creating a scene. Existing P0 state remains version 1.
	if not s.player is Dictionary or not s.core is Dictionary or not s.stats is Dictionary: return {}
	if not s.player.has_all(["character","pos","hp","inventory","weapons","slot","magazines"]) or not s.core.has_all(["pos","hp","max_hp"]): return {}
	if not s.player.pos is Vector2 or not s.core.pos is Vector2 or not s.player.inventory is Dictionary: return {}
	if not s.player.character is int or s.player.character<0 or s.player.character>=MayhemCatalog.CHARACTERS.size(): return {}
	if not s.structures is Array or not s.has_all(["sources","enemies","projectiles","packets","loot","elapsed","raid_clock","attack_seed","world_seed"]): return {}
	if not s.player.weapons is Array or not s.player.magazines is Array or s.player.weapons.size()!=2 or s.player.magazines.size()!=2: return {}
	if not s.stats.has_all(["seconds","peak_wave","attempt","player","team","history"]): return {}
	if not s.stats.player is Dictionary or not s.stats.team is Dictionary: return {}
	if not s.stats.player.has_all(["damage","kills","gathered","repair"]) or not s.stats.team.has_all(["damage","kills","production"]): return {}
	for b in s.structures:
		if not b is Dictionary or not b.has_all(["kind","pos","id","hp","built","input","output","stock","max_hp","level","enabled","links","progress","delivered","work","cooldown","flow","powered"]): return {}
		if not MayhemCatalog.BUILDINGS.has(b.kind) or not b.pos is Vector2: return {}
		if not shape(b,MayhemCatalog.building(b.kind,Vector2.ZERO,0)): return {}
	if s.phase not in ["prepare","warning","attack"] or s.player.slot not in [-1,0,1]: return {}
	for weapon in s.player.weapons:
		if weapon not in ["","bow","scatter"]: return {}
	for stock in [s.player.inventory]:
		if not stock_valid(stock): return {}
	var schemas: Dictionary={
		"sources":{"kind":"","pos":Vector2.ZERO,"cooldown":0.0,"left":0},
		"enemies":{"id":0,"kind":"","pos":Vector2.ZERO,"hp":0.0,"max_hp":0.0,"main":false,"cd":0.0,"flash":0.0,"nav":0.0,"path":PackedVector2Array()},
		"projectiles":{"pos":Vector2.ZERO,"dir":Vector2.ZERO,"damage":0.0,"source":"","life":0.0},
		"loot":{"pos":Vector2.ZERO,"kind":"","amount":0},
		"packets":{"belt":0,"target":0,"kind":"","amount":0,"from":Vector2.ZERO,"to":Vector2.ZERO,"pos":Vector2.ZERO,"progress":0.0}
	}
	for key in schemas:
		if not s[key] is Array: return {}
		for item in s[key]:
			if not shape(item,schemas[key]): return {}
			if key=="enemies" and item.kind not in ["normal","runner","siege","saboteur","boss"]: return {}
	for b in s.structures:
		for stock in [b.input,b.output,b.stock,b.delivered]:
			if not stock_valid(stock): return {}
	return s
static func stock_valid(stock: Variant) -> bool:
	if not stock is Dictionary: return false
	for item in stock:
		if not item is String or not stock[item] is int or stock[item]<0: return false
	return true
static func remember(s: Dictionary,reason: String) -> bool:
	var payload: Dictionary={"version":1,"stats":s.stats.duplicate(true),"reason":reason}
	var file:=FileAccess.open("user://last_statistics.json.tmp",FileAccess.WRITE)
	if file==null: return false
	file.store_string(JSON.stringify(payload))
	file.close()
	return DirAccess.rename_absolute("user://last_statistics.json.tmp","user://last_statistics.json")==OK
static func statistics() -> Dictionary:
	var suspended:=suspend()
	if not suspended.is_empty(): return {"stats":suspended.stats,"reason":"Ara verme kaydı"}
	if not FileAccess.file_exists("user://last_statistics.json"): return {}
	var file:=FileAccess.open("user://last_statistics.json",FileAccess.READ)
	if file==null: return {}
	var data=JSON.parse_string(file.get_as_text())
	if not data is Dictionary or data.get("version")!=1 or not data.get("stats") is Dictionary: return {}
	if not data.get("reason") is String or not shape(data.stats,SessionStatistics.fresh()): return {}
	var stats: Dictionary=data.stats
	if not stats.has_all(["seconds","peak_wave","attempt","player","team"]) or not stats.player is Dictionary or not stats.team is Dictionary: return {}
	if not stats.player.has_all(["damage","kills","gathered","repair"]) or not stats.team.has_all(["damage","kills","production"]): return {}
	return data

static func shape(value: Variant,sample: Variant) -> bool:
	if sample is Dictionary:
		if not value is Dictionary: return false
		for key in sample:
			if not value.has(key) or not shape(value[key],sample[key]): return false
		return true
	if sample is Array: return value is Array
	if sample is int or sample is float:
		return (value is int or value is float) and is_finite(float(value))
	if sample is Vector2: return value is Vector2 and value.is_finite()
	return typeof(value)==typeof(sample)
