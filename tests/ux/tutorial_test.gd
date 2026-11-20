extends SceneTree
var failures := 0
var checks := 0
var game: Node
func check(ok: bool, text: String) -> void:
	checks+=1
	if ok: print("PASS ",text)
	else: failures+=1; push_error(text)
func advance(seconds: float) -> void:
	for i in range(ceili(seconds/0.05)): game.sim.tick(0.05)
	game.refresh_ui()
func gather(kind: String, count: int) -> void:
	var s: Dictionary=game.sim.state
	game.hud.close_panel()
	for source in s.sources:
		if source.kind!=kind: continue
		game.selection={"type":"source","data":source}
		s.player.pos=source.pos
		for unused in range(30):
			if s.player.inventory.get(kind,0)>=count: break
			advance(0.75)
			game.action("context")
func press(text: String) -> void:
	for child in game.hud.panel_body.get_children():
		if child is Button and child.text.begins_with(text):
			child.pressed.emit()
			return
	check(false,"Missing mobile button "+text)
func build(kind: String,at: Vector2) -> Dictionary:
	var s: Dictionary=game.sim.state
	for item in MayhemCatalog.BUILDINGS[kind].cost: gather(item,MayhemCatalog.BUILDINGS[kind].cost[item])
	game.action("build")
	game.hud.choose_building(kind)
	game.ghost=at
	var before: int=s.structures.size()
	game.action("context")
	check(s.structures.size()==before+1,"Mobile confirmation places "+kind)
	var b: Dictionary=s.structures[-1]
	s.player.pos=b.pos+Vector2(0,65)
	game.selection={"type":"building","data":b}
	game.action("context")
	advance(MayhemCatalog.BUILDINGS[kind].time+0.1)
	check(b.built,"Physical delivery builds "+kind)
	return b
func _initialize() -> void: call_deferred("run")
func run() -> void:
	game=load("res://prototype/scenes/session.tscn").instantiate()
	root.add_child(game)
	current_scene=game
	await process_frame
	game.set_process(false)
	game.action("new")
	var s: Dictionary=game.sim.state
	check(s.tutorial.step==0 and TutorialGuide.task(s).progress=="Odun: 0/2","Tutorial begins with actual wood counter")
	gather("wood",2)
	check(s.tutorial.step==1 and TutorialGuide.task(s).progress=="Taş: 0/4","Wood collection triggers stone goal")
	gather("stone",4)
	check(s.tutorial.step==2,"Stone triggers placement goal")
	var smelter:=build("smelter",Vector2(720,600))
	check(s.tutorial.step==4,"Placed, delivered, finished smelter triggers metal goal")
	game.action("save")
	game.action("resume")
	s=game.sim.state
	smelter=s.structures[0]
	check(s.tutorial.step==4,"Suspend/resume preserves exact tutorial step")
	game.action("tutorial_skip")
	advance(0.1)
	check(s.tutorial.skipped and not game.hud.mission.visible,"Tutorial can be skipped without blocking gameplay")
	game.action("save"); game.action("resume")
	s=game.sim.state
	smelter=s.structures[0]
	check(s.tutorial.skipped,"Skip preference survives reload")
	game.action("tutorial_toggle")
	check(not s.tutorial.skipped and s.tutorial.step==4,"Reopen resumes same step")
	gather("ore",2); gather("wood",1)
	s.player.pos=smelter.pos+Vector2(0,65)
	game.selection={"type":"building","data":smelter}
	game.action("context")
	press("Girdi yükle")
	advance(3.1)
	check(s.tutorial.step==4 and smelter.output.get("metal",0)>=2,"Produced metal must physically reach player")
	press("Ürünleri al")
	check(s.tutorial.step==5,"Collecting metal advances tutorial")
	game.hud.close_panel()
	var ammo:=build("ammo_bench",Vector2(790,620))
	check(s.tutorial.step==6,"Ammo building teaches its own construction materials")
	gather("wood",1)
	s.player.pos=ammo.pos+Vector2(0,65)
	game.selection={"type":"building","data":ammo}
	game.action("context")
	press("Girdi yükle"); advance(2.6); press("Ürünleri al")
	check(s.tutorial.step==7 and s.player.inventory.get("ammo",0)>=8,"Ammo recipe produces carried physical ammunition")
	game.hud.close_panel()
	var turret:=build("turret",Vector2(540,620))
	check(s.tutorial.step==8 and turret.input.is_empty(),"New tower does not auto-spend carried ammo")
	game.action("context"); press("Mühimmat yükle")
	check(s.tutorial.step==9 and turret.input.get("ammo",0)>0,"Loading tower advances defense goal")
	game.hud.close_panel()
	# Same scripted player support as legacy P0 loop: real movement, melee, turret projectiles.
	s.player.pos=s.core.pos+Vector2(0,90)
	game.hud.show_panel("options"); press("Saldırıyı başlat")
	check(s.phase=="warning" and game.hud.open_panel=="","Normal mobile menu starts attack")
	for tick in range(2200):
		if s.wave>=2 or s.lost: break
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
				movement=(route[1]-s.player.pos).normalized() if route.size()>1 else aim
			if offset.length()<110: CombatSystem.skill(s)
		game.sim.tick(0.05,movement,aim)
	game.refresh_ui()
	check(not s.lost and s.wave==2 and s.tutorial.step==TutorialGuide.STEPS.size(),"Full gather/production/build/defense tutorial completes")
	check(s.stats.team.damage>0,"Loaded tower still contributes real projectile damage")
	var old: Dictionary=s.duplicate(true)
	old.erase("tutorial")
	TutorialGuide.ensure(old)
	check(old.tutorial.step==TutorialGuide.STEPS.size(),"Pre-UX progressed saves migrate without resetting world")
	game.queue_free(); await process_frame
	print("TUTORIAL: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
