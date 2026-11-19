class_name ProductionSystem
extends RefCounted
const BUFFER = 24
static func tick(s: Dictionary, dt: float) -> void:
	for b in s.structures:
		if not b.built or not b.enabled or not MayhemCatalog.RECIPES.has(b.kind): continue
		if b.kind=="electric_bench" and not b.powered: continue
		var recipe: Dictionary = MayhemCatalog.RECIPES[b.kind]
		if not PhysicalInventory.has(b.input,recipe.input) or PhysicalInventory.total(b.output)+PhysicalInventory.total(recipe.output)>BUFFER: continue
		b.work += dt*(b.hp/b.max_hp)*b.level
		if b.work>=recipe.time:
			PhysicalInventory.remove(b.input,recipe.input)
			for item in recipe.output:
				PhysicalInventory.add(b.output,item,recipe.output[item],BUFFER)
				s.stats.team.production+=recipe.output[item]
			b.work-=recipe.time
static func load_input(s: Dictionary, b: Dictionary) -> int:
	if not b.built or s.player.pos.distance_to(b.pos)>MayhemCatalog.REACH: return 0
	var moved := 0
	if b.kind=="depot":
		for item in s.player.inventory.keys():
			moved+=PhysicalInventory.transfer(s.player.inventory,b.stock,item,999,60)
	elif b.kind=="turret":
		moved=PhysicalInventory.transfer(s.player.inventory,b.input,"ammo",999,32)
	elif MayhemCatalog.RECIPES.has(b.kind):
		for item in MayhemCatalog.RECIPES[b.kind].input:
			moved+=PhysicalInventory.transfer(s.player.inventory,b.input,item,999,BUFFER)
	return moved
static func collect(s: Dictionary, b: Dictionary) -> int:
	if s.player.pos.distance_to(b.pos)>MayhemCatalog.REACH: return 0
	var source: Dictionary = b.stock if b.kind=="depot" else b.output
	var moved := 0
	for item in source.keys():
		moved+=PhysicalInventory.transfer(source,s.player.inventory,item,999,30)
	return moved
static func upgrade(s: Dictionary, b: Dictionary) -> bool:
	if not b.built or b.level>=3 or s.player.pos.distance_to(b.pos)>MayhemCatalog.REACH: return false
	if not PhysicalInventory.remove(s.player.inventory,{"metal":2,"wood":2}): return false
	b.level+=1
	return true
