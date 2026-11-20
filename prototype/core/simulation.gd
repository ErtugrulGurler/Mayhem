class_name MayhemSimulation
extends RefCounted
signal checkpoint_due
var state: Dictionary
func _init(initial: Dictionary = {}) -> void:
	state=MayhemState.fresh() if initial.is_empty() else initial
	TutorialGuide.ensure(state)
func tick(dt: float,movement: Vector2=Vector2.ZERO,aim: Vector2=Vector2.ZERO) -> void:
	if state.lost: return
	state.core.repair_cd=maxf(0,state.core.repair_cd-dt)
	state.elapsed+=dt
	state.stats.seconds+=dt
	PlayerSystem.tick(state,dt,movement)
	if not state.player.down: CombatSystem.attack(state,aim)
	BuildingSystem.tick(state,dt)
	PowerGraph.tick(state)
	ProductionSystem.tick(state,dt)
	LogisticsSystem.tick(state,dt)
	CombatSystem.tick(state,dt)
	EnemySystem.tick(state,dt)
	var checkpoint := MayhemWaves.tick(state,dt)
	TutorialGuide.observe(state)
	if checkpoint: checkpoint_due.emit()
func nearest() -> Dictionary:
	var result: Dictionary={}
	var distance:=MayhemCatalog.REACH
	for b in state.structures:
		var d: float=state.player.pos.distance_to(b.pos)
		if d<distance:
			result=b
			distance=d
	return result
func interact() -> String:
	if state.player.down: return "Yaralısın; kliniğe sürün veya kan kaybını bekle."
	var b:=nearest()
	if not b.is_empty():
		if not b.built: return "Teslim: %d" % BuildingSystem.deliver(state,b)
		if b.kind=="clinic": return "Klinik: %s" % PlayerSystem.clinic(state,b)
	if PlayerSystem.gather(state): return "Malzeme alındı."
	if not b.is_empty(): return "Çıktı alındı: %d" % ProductionSystem.collect(state,b)
	return "Kaynağa / şantiyeye / ürün kutusuna yaklaş."
