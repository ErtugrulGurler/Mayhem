extends SceneTree
var checks:=0
var failures:=0
var sim: MayhemSimulation
func check(ok: bool,text: String) -> void:
	checks+=1
	if ok: print("PASS ",text)
	else:
		failures+=1
		push_error("FAIL "+text)
func harvest(kind: String,amount: int) -> void:
	var s: Dictionary=sim.state
	for source in s.sources:
		if source.kind==kind:
			s.player.pos=source.pos
			for i in range(ceili(amount/2.0)):
				PlayerSystem.tick(s,0.8,Vector2.ZERO)
				PlayerSystem.gather(s)
func build(kind: String,at: Vector2) -> Dictionary:
	var s: Dictionary=sim.state
	for item in MayhemCatalog.BUILDINGS[kind].cost:
		harvest(item,MayhemCatalog.BUILDINGS[kind].cost[item])
	s.player.pos=at+Vector2(0,70)
	var b:=BuildingSystem.place(s,kind,at)
	if b.is_empty():
		check(false,"build fixture failed: "+kind)
		return {}
	check(not b.built,"E2E "+kind+" starts as material-less construction site")
	BuildingSystem.deliver(s,b)
	s.player.pos=s.core.pos+Vector2(0,90)
	for i in range(120): sim.tick(0.05)
	check(b.built,"E2E "+kind+" finishes with harvested delivered materials")
	return b
func _initialize() -> void: call_deferred("run")
func run() -> void:
	sim=MayhemSimulation.new()
	var s: Dictionary=sim.state
	var smelter:=build("smelter",Vector2(720,600))
	var ammo:=build("ammo_bench",Vector2(790,620))
	var turret:=build("turret",Vector2(540,620))
	if smelter.is_empty() or ammo.is_empty() or turret.is_empty(): quit(1); return
	harvest("ore",8)
	harvest("wood",4)
	s.player.pos=smelter.pos+Vector2(0,65)
	check(ProductionSystem.load_input(s,smelter)==12,"E2E physical ore and fuel loaded")
	for i in range(250): sim.tick(0.05)
	check(smelter.output.get("metal",0)==8,"E2E ore becomes metal")
	ProductionSystem.collect(s,smelter)
	harvest("wood",8)
	s.player.pos=ammo.pos+Vector2(0,65)
	ProductionSystem.load_input(s,ammo)
	for i in range(180): sim.tick(0.05)
	ProductionSystem.collect(s,ammo)
	for i in range(120): sim.tick(0.05)
	ProductionSystem.collect(s,ammo)
	check(s.player.inventory.get("ammo",0)>0,"E2E metal becomes carried ammunition")
	s.player.pos=turret.pos+Vector2(0,70)
	ProductionSystem.load_input(s,turret)
	check(turret.input.get("ammo",0)>0,"E2E physical ammo delivered to defense")
	s.player.pos=s.core.pos+Vector2(0,90)
	check(MayhemWaves.begin(s) and s.phase=="warning","E2E attack warning before spawn")
	var safety:=0
	while s.wave==1 and not s.lost and safety<2200:
		var movement:=Vector2.ZERO
		var aim:=Vector2.ZERO
		if not s.enemies.is_empty():
			var nearest: Dictionary=s.enemies[0]
			for e in s.enemies:
				if s.player.pos.distance_to(e.pos)<s.player.pos.distance_to(nearest.pos): nearest=e
			var offset: Vector2=nearest.pos-s.player.pos
			aim=offset.normalized()
			if offset.length()>60:
				var route:=MayhemTerrain.path(s.player.pos,nearest.pos,s.structures)
				if route.size()>1: movement=(route[1]-s.player.pos).normalized()
				else: movement=aim
			if offset.length()<110: CombatSystem.skill(s)
		sim.tick(0.05,movement,aim)
		safety+=1
	print("Loop observation: wave=",s.wave," lost=",s.lost," structures=",s.structures.size()," remaining=",s.enemies.size()," team damage=",s.stats.team.damage)
	check(s.wave==2 and not s.lost and s.stats.team.damage>0,"E2E active player and loaded turret resolve actual first wave")
	# Explicit UNRANKED checkpoint fixture after the verified first-wave loop.
	s.unranked=true
	s.wave=5
	s.phase="prepare"
	s.enemies.clear()
	MayhemWaves.begin(s)
	for i in range(101): sim.tick(0.05)
	var elite:=false
	for e in s.enemies:
		if e.kind=="siege": elite=true
	check(elite,"ENM-004 wave five strong attacker")
	# Checkpoint transition is isolated from combat balance: remove fixture assault.
	s.enemies.clear()
	s.spawn_left=0
	var saved: Array=[]
	sim.checkpoint_due.connect(func(): saved.append(sim.state.duplicate(true)))
	sim.tick(0.05)
	check(s.wave==6 and saved.size()==1,"SAV-001 fifth wave completion emits checkpoint once")
	check(MayhemSave.write("user://p0_loop.bin",saved[0]),"E2E full post-production checkpoint saved")
	var restored:=MayhemSave.read("user://p0_loop.bin")
	check(restored.structures.size()==3 and restored.structures[0].output==smelter.output and restored.unranked,"E2E checkpoint restores physical production world")
	s.wave=10
	s.phase="prepare"
	s.enemies.clear()
	MayhemWaves.begin(s)
	check(s.boss_id=="boss_10" and s.phase=="warning","ENM-008 fixed boss identity and warning")
	for i in range(101): sim.tick(0.05)
	var boss:=false
	for e in s.enemies:
		if e.kind=="boss": boss=true
	check(boss,"ENM-004 wave ten spawns boss")
	DirAccess.remove_absolute("user://p0_loop.bin")
	print("LOOP: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
