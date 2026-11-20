extends SceneTree
var checks:=0
var failures:=0
func check(ok: bool,text: String) -> void:
	checks+=1
	if ok: print("PASS ",text)
	else: failures+=1; push_error(text)
func click(button: Control) -> void:
	var at:=button.get_global_rect().get_center()
	var motion:=InputEventMouseMotion.new()
	motion.position=at
	motion.global_position=at
	root.push_input(motion,true)
	await process_frame
	for down in [true,false]:
		var event:=InputEventMouseButton.new()
		event.position=at
		event.global_position=at
		event.button_index=MOUSE_BUTTON_LEFT
		event.pressed=down
		root.push_input(event,true)
		await process_frame
	await process_frame
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var game=load("res://prototype/scenes/session.tscn").instantiate()
	root.add_child(game); current_scene=game
	await process_frame
	game.set_process(false)
	await click(game.hud.controls.start)
	check(game.running,"Real GUI mouse events activate start button")
	await click(game.hud.controls.build)
	check(game.hud.open_panel=="build","Real GUI mouse events open build panel")
	if game.hud.open_panel=="build":
		var first: Button=game.hud.panel_body.get_child(0)
		check(first.text.begins_with("Önerilen") and first.text.contains("İzabe"),"First recipe is the tutorial's recommended smelter")
		await click(first)
		check(game.build_kind=="smelter" and game.hud.open_panel=="","Recipe choice starts a preview, not instant construction")
		await click(game.hud.controls.context)
		check(game.sim.state.structures.size()==1 and not game.sim.state.structures[0].built,"Confirmation click creates a material-less site")
	await click(game.hud.menu_button)
	check(game.hud.open_panel=="options","Menu can be opened with actual pointer dispatch")
	check(not game.router.enabled,"Open panel releases and disables stick owners")
	await click(game.hud.panel_close)
	check(game.hud.open_panel=="" and game.router.enabled,"Closing panel restores sticks")
	var before: int=game.sim.state.structures.size()
	var fake:=InputEventMouseButton.new()
	fake.position=game.router.centers[0]
	fake.button_index=MOUSE_BUTTON_LEFT
	fake.pressed=true
	game.build_kind="wall"
	root.push_input(fake,true)
	await process_frame
	check(game.sim.state.structures.size()==before,"Pointer in analog area cannot place buildings")
	game.action("cancel_build")
	for down in [true,false]:
		var tap:=InputEventScreenTouch.new()
		tap.index=0
		tap.pressed=down
		tap.position=game.hud.controls.build.get_global_rect().get_center()
		root.push_input(tap,true)
		await process_frame
	check(game.hud.open_panel=="build","Synthetic touchscreen tap reaches mobile build button")
	game.hud.close_panel()
	for side in range(2):
		var tap:=InputEventScreenTouch.new()
		tap.index=11+side
		tap.pressed=true
		tap.position=game.router.centers[side]+Vector2(40,0)
		root.push_input(tap,true)
		await process_frame
	for down in [true,false]:
		var tap:=InputEventScreenTouch.new()
		tap.index=13
		tap.pressed=down
		tap.position=game.hud.controls.skill.get_global_rect().get_center()
		root.push_input(tap,true)
		await process_frame
	check(game.sim.state.player.skill_cd>0 and game.router.owners.size()==2,"Third touch activates skill while both stick IDs remain owned")
	game.router.clear()
	game.queue_free(); await process_frame
	print("POINTER: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
