extends SceneTree
## Optional graphical capture: MAYHEM_GAIT_FRAMES points to a writable directory.
const DT := 1.0/60
var errors := 0
var checks := 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		errors += 1
		push_error(message)

func _initialize() -> void: call_deferred("run")

func run() -> void:
	var destination := OS.get_environment("MAYHEM_GAIT_FRAMES")
	if not destination.is_empty():
		DirAccess.make_dir_recursive_absolute(destination)
		root.size = Vector2i(960,540)
	var app = load("res://ui/main_menu.tscn").instantiate()
	root.add_child(app)
	await process_frame
	app.new_setup()
	app.commit_new()
	var game: Node = app.game
	game.set_process(false)
	game.action("tutorial_skip")
	for n in 4: game.action("zoom_in")
	var snapshot: Dictionary = game.sim.state.duplicate(true)
	snapshot.player.pos = Vector2(1060,970)
	var reference := Vector2.ZERO
	var styles := {}
	var maximum_slip := 0.0
	var support_samples := 0
	for index in 5:
		game.sim.state = snapshot.duplicate(true)
		game.refresh_ui()
		var motion = game.view.actor.motion
		if index: game.hud.gait_button.pressed.emit()
		check(motion.gaits.selected == index and game.hud.gait_button.text == motion.gaits.NAMES[index], "HUD and gait agree")
		game.router.update_pad(0,game.router.centers[0]+Vector2(58,0))
		var trace := PackedFloat32Array()
		var last_ankle := Vector2.ZERO
		var held := false
		for tick in 96:
			game._process(DT)
			if tick < 24: continue
			trace.append(motion.bones.near_leg.rotation)
			if index == 4:
				var foot: Vector2 = motion.bones.near_foot.global_position
				var support: bool = motion.gaits.planted.has("near")
				if held and support:
					maximum_slip = maxf(maximum_slip, foot.distance_to(last_ankle))
					support_samples += 1
				held = support
				last_ankle = foot
			if not destination.is_empty() and tick%2 == 0:
				await process_frame
				await RenderingServer.frame_post_draw
				var image := root.get_texture().get_image().get_region(Rect2i(380,125,200,185))
				check(image.save_png(destination.path_join("%d-%03d.png"%[index,tick])) == OK,"Save pose")
		styles[hash(trace)] = true
		var finish: Vector2 = game.sim.state.player.pos
		if index == 0: reference = finish
		check(finish.is_equal_approx(reference),"All gaits cover identical distance")
	check(styles.size()==5,"Five distinct hip trajectories")
	check(support_samples>=10 and maximum_slip<1.5,"Planted ankle stays within 1.5 world units per tick")
	for pressed in [true,false]:
		var touch := InputEventScreenTouch.new()
		touch.position = game.hud.gait_button.get_global_rect().get_center()
		touch.pressed = pressed
		root.push_input(touch,true)
		await process_frame
	check(game.hud.gait_button.text=="Original","Button wraps to Original")
	print("RUN COMPARISON: ",checks," checks, ",errors," failures; planted ankle max step ",maximum_slip," world units over ",support_samples," samples")
	quit(int(errors>0))
