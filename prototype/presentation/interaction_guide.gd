class_name InteractionGuide
extends RefCounted
## One shared context decision for highlighting, labels and mobile commands.
static func target(s: Dictionary, selected: Dictionary = {}) -> Dictionary:
	if not selected.is_empty() and exists(s,selected) and s.player.pos.distance_to(selected.data.pos)<=MayhemCatalog.REACH:
		return selected
	var best: Dictionary = {}
	var distance := MayhemCatalog.REACH
	for pair in [["source",s.sources],["building",s.structures],["loot",s.loot],["core",[s.core]]]:
		for data in pair[1]:
			if pair[0]=="loot" and data.kind in ["heal","speed"]: continue
			var d: float = s.player.pos.distance_to(data.pos)
			if d < distance:
				distance = d
				best = {"type":pair[0],"data":data}
	return best

static func exists(s: Dictionary, selection: Dictionary) -> bool:
	match selection.get("type",""):
		"building": return s.structures.has(selection.data)
		"source": return s.sources.has(selection.data)
		"loot": return s.loot.has(selection.data)
		"core": return true
	return false

static func title(t: Dictionary) -> String:
	if t.is_empty(): return "Bir nesneye yaklaş"
	match t.type:
		"building": return MayhemCatalog.BUILDINGS[t.data.kind].name
		"source": return MayhemCatalog.LABELS[t.data.kind].capitalize() + " kaynağı"
		"core": return "Merkez"
	return MayhemCatalog.LABELS.get(t.data.kind,t.data.kind).capitalize()

static func primary(t: Dictionary) -> String:
	if t.is_empty(): return "Nesneye yaklaş"
	match t.type:
		"source": return "%s topla" % MayhemCatalog.LABELS[t.data.kind].capitalize()
		"loot": return "Yerden al"
		"building": return "Teslim et" if not t.data.built else "Tesisi aç"
	return "Merkezi aç"

static func status(b: Dictionary) -> String:
	if not b.built:
		return "İnşa ediliyor" if PhysicalInventory.has(b.delivered,MayhemCatalog.BUILDINGS[b.kind].cost) else "Malzeme bekliyor"
	if not b.enabled: return "Kapalı"
	if b.kind=="electric_bench" and not b.powered: return "Enerji yok"
	if b.kind=="turret": return "Mühimmat yok" if b.input.get("ammo",0)==0 else "Savunmaya hazır"
	if MayhemCatalog.RECIPES.has(b.kind):
		var recipe: Dictionary = MayhemCatalog.RECIPES[b.kind]
		if PhysicalInventory.total(b.output)+PhysicalInventory.total(recipe.output)>ProductionSystem.BUFFER: return "Çıktı dolu"
		if not PhysicalInventory.has(b.input,recipe.input): return "Girdi yok"
		return "Üretiliyor"
	return "Hazır"
