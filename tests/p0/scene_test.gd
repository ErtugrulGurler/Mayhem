extends SceneTree
var checks:=0
var failures:=0
func check(ok: bool,text: String) -> void:
	checks+=1
	if ok: print("PASS ",text)
	else:
		failures+=1
		push_error("FAIL "+text)
func touch(id: int,pressed: bool,at: Vector2) -> InputEventScreenTouch:
	var e:=InputEventScreenTouch.new()
	e.index=id
	e.pressed=pressed
	e.position=at
	return e
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var game=load("res://prototype/scenes/session.tscn").instantiate()
	root.add_child(game)
	current_scene=game
	await process_frame
	game.set_process(false)
	check(game.hud.menu.visible and not game.running,"F5 exposes character and map selection")
	game.hud.character.select(3)
	game.hud.location.select(1)
	game.hud.variation.select(1)
	game.action("new")
	check(game.running and game.sim.state.player.character==3 and game.sim.state.location==1,"Menu selection starts correct empty session")
	var start: Vector2=game.sim.state.player.pos
	game.sim.tick(0.1,Vector2.RIGHT)
	game._process(0)
	check(game.camera.position==game.sim.state.player.pos and game.sim.state.player.pos.x>start.x,"SYS-001 camera follows moving player")
	game.action("zoom_in")
	check(game.camera.zoom.x>1.2,"SYS-001 zoom changes within limits")
	game.router._input(touch(1,true,Vector2(130,395)))
	game.router._input(touch(2,true,Vector2(870,345)))
	check(game.router.movement.x>0.5 and game.router.aim.y< -0.5 and game.router.owners.size()==2,"CBT-001 independent simultaneous touch IDs (synthetic)")
	game.router._input(touch(1,false,Vector2(130,395)))
	check(game.router.movement==Vector2.ZERO and game.router.aim.y<0,"CBT-016 releasing move does not release aim")
	game.router._input(touch(3,true,Vector2(480,390)))
	check(not game.router.owners.has(3),"NFR-006 action HUD area not captured as stick")
	game.router.clear()
	game.action("debug")
	check(game.sim.state.unranked and game.sim.state.wave==5,"Debug skips are explicitly UNRANKED")
	game.action("save")
	var state: Dictionary=game.sim.state.duplicate(true)
	game.sim.state.player.pos+=Vector2(10,0)
	game.action("resume")
	check(var_to_bytes(game.sim.state)==var_to_bytes(state),"Save/Resume UI restores exact state")
	game.sim.state.lost=true
	game._process(0)
	game.action("resume")
	check(game.sim.state.lost and not FileAccess.file_exists("user://suspend.bin"),"SAV-003 defeat invalidates suspend save")
	game.action("retry")
	check(not game.sim.state.lost and game.sim.state.stats.attempt==1,"SAV-003 retry UI returns to checkpoint")
	game.action("new")
	check(game.sim.state.wave==1 and game.sim.state.structures.is_empty(),"SYS-002 new session resets progress")
	game.queue_free()
	await process_frame
	print("SCENE: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
