class_name TutorialGuide
extends RefCounted
## Observes physical world state; never grants items, gates commands or changes waves.
const STEPS = [
	"Odun topla", "Taş topla", "İlk tesisi yerleştir",
	"İzabeyi tamamla", "Metal üret ve al", "Mühimmat tezgâhını kur",
	"Mühimmat üret ve al", "Savunma kulesi kur", "Kuleye mühimmat yükle",
	"İlk saldırıyı karşıla"
]
static func ensure(s: Dictionary) -> void:
	if s.has("tutorial"): return
	var step := 0
	if s.wave > 1: step = STEPS.size()
	elif not structures(s, "turret", true).is_empty(): step = 8
	elif not structures(s, "ammo_bench", true).is_empty(): step = 6
	elif not structures(s, "smelter", true).is_empty(): step = 4
	s.tutorial = {"step":step, "skipped":false}

static func structures(s: Dictionary, kind: String, built_only: bool = false) -> Array:
	var found: Array = []
	for b in s.structures:
		if b.kind == kind and (not built_only or b.built): found.append(b)
	return found

static func observe(s: Dictionary) -> void:
	ensure(s)
	if s.tutorial.skipped: return
	for unused in range(STEPS.size()):
		var step: int = s.tutorial.step
		if step >= STEPS.size(): return
		var done := false
		match step:
			0: done = s.player.inventory.get("wood",0) >= 2
			1: done = s.player.inventory.get("stone",0) >= 4
			2: done = not structures(s,"smelter").is_empty()
			3: done = not structures(s,"smelter",true).is_empty()
			4: done = s.player.inventory.get("metal",0) >= 2
			5: done = not structures(s,"ammo_bench",true).is_empty()
			6: done = s.player.inventory.get("ammo",0) >= 8
			7: done = not structures(s,"turret",true).is_empty()
			8:
				for b in structures(s,"turret",true):
					if b.input.get("ammo",0) > 0: done = true
			9: done = s.wave >= 2
		if not done: return
		s.tutorial.step += 1

static func source(s: Dictionary, kind: String) -> Vector2:
	for item in s.sources:
		if item.kind == kind: return item.pos
	return s.core.pos

static func building_task(s: Dictionary, kind: String) -> Dictionary:
	var sites := structures(s,kind)
	var cost: Dictionary = MayhemCatalog.BUILDINGS[kind].cost
	var b: Dictionary = {} if sites.is_empty() else sites[0]
	if not b.is_empty() and b.built:
		return {"hint":"Tesis hazır.", "target":b.pos, "progress":"Hazır"}
	for item in cost:
		var delivered: int = 0 if b.is_empty() else int(b.delivered.get(item,0))
		var owned: int = int(s.player.inventory.get(item,0))
		if delivered + owned < cost[item]:
			return {"hint":"%s topla: %d/%d. Kaynağa yaklaş → Topla." % [MayhemCatalog.LABELS[item].capitalize(), delivered+owned,cost[item]],
				"target":source(s,item),"progress":"%d/%d" % [delivered+owned,cost[item]]}
	if b.is_empty():
		return {"hint":"İnşa → %s seç. Yeşil alana dokun → Yerleştir." % MayhemCatalog.BUILDINGS[kind].name,
			"target":s.core.pos+Vector2(0,-110),"progress":"Malzemeler hazır","build":kind}
	var total := PhysicalInventory.total(b.delivered)
	var required := PhysicalInventory.total(cost)
	return {"hint":"Şantiyeye yaklaş → Teslim et." if total<required else "İnşaat sürüyor. Başında beklemen gerekmez.",
		"target":b.pos,"progress":"Teslim %d/%d" % [total,required]}

static func production_task(s: Dictionary, kind: String, product: String, amount: int) -> Dictionary:
	var sites := structures(s,kind,true)
	if sites.is_empty(): return building_task(s,kind)
	var b: Dictionary = sites[0]
	var carried: int = s.player.inventory.get(product,0)
	if b.output.get(product,0)>0:
		return {"hint":"Ürün hazır! Tesisi aç → Ürünleri al.", "target":b.pos, "progress":"Çantada %d/%d" % [carried,amount]}
	var recipe: Dictionary = MayhemCatalog.RECIPES[kind]
	for item in recipe.input:
		var stocked: int = b.input.get(item,0)
		var owned: int = s.player.inventory.get(item,0)
		if stocked<recipe.input[item] and stocked+owned<recipe.input[item]:
			if item=="metal": return production_task(s,"smelter","metal",recipe.input[item])
			var label: String = MayhemCatalog.LABELS[item]
			return {"hint":"%s topla: %d/%d. Sonra %s tesisine taşı." % [label.capitalize(),stocked+owned,recipe.input[item],MayhemCatalog.BUILDINGS[kind].name],
				"target":source(s,item) if item in ["wood","ore","stone"] else closest_metal(s),
				"progress":"%s %d/%d" % [label,stocked+owned,recipe.input[item]]}
	if not PhysicalInventory.has(b.input,recipe.input):
		return {"hint":"Tesisi aç → Girdi yükle. Çantadaki tarif malzemeleri aktarılır.", "target":b.pos, "progress":"Girdi bekliyor"}
	return {"hint":"Üretiliyor… Hazır olunca tesisten Ürünleri al.", "target":b.pos, "progress":"%s %d/%d" % [MayhemCatalog.LABELS[product],carried,amount]}

static func closest_metal(s: Dictionary) -> Vector2:
	var sites := structures(s,"smelter",true)
	return s.core.pos if sites.is_empty() else sites[0].pos

static func task(s: Dictionary) -> Dictionary:
	ensure(s)
	var step: int = s.tutorial.step
	if step >= STEPS.size():
		return {"title":"İlk savunma tamamlandı!", "hint":"Artık kendi üretim hattını büyütebilirsin.", "progress":"Tamamlandı","target":s.core.pos}
	var data: Dictionary = {}
	match step:
		0,1:
			var item: String = "wood" if step==0 else "stone"
			var required := 2 if step==0 else 4
			var count: int = mini(required,s.player.inventory.get(item,0))
			data = {"hint":"İşaretli kaynağa sol analogla yaklaş → Topla düğmesine dokun.", "target":source(s,item),
				"progress":"%s: %d/%d" % [MayhemCatalog.LABELS[item].capitalize(),count,required]}
		2,3: data = building_task(s,"smelter")
		4: data = production_task(s,"smelter","metal",2)
		5: data = building_task(s,"ammo_bench")
		6: data = production_task(s,"ammo_bench","ammo",8)
		7: data = building_task(s,"turret")
		8:
			var turrets := structures(s,"turret",true)
			if turrets.is_empty(): data = building_task(s,"turret")
			elif s.player.inventory.get("ammo",0)==0:
				data = production_task(s,"ammo_bench","ammo",8)
			else: data = {"hint":"Kuleyi aç → Mühimmat yükle. Boş kule ateş edemez.", "target":turrets[0].pos, "progress":"Mühimmat bekliyor"}
		9: data = {"hint":"Menü → Saldırıyı başlat. Sağ analogla yakın dövüş yap; üretim tesislerini de koru." if s.phase=="prepare" else "Kuleyle birlikte düşmanları durdur. Yakın dövüş için sağ analoğu düşmana tut.",
			"target":s.core.pos,"progress":"Bölüm 1 savunması"}
	data.title = "%d/%d · %s" % [step+1,STEPS.size(),STEPS[step]]
	return data

static func recommended_build(s: Dictionary) -> String:
	ensure(s)
	if s.tutorial.skipped: return ""
	match s.tutorial.step:
		0,1,2,3: return "smelter"
		5: return "ammo_bench"
		7: return "turret"
	return ""
