extends SceneTree
## Set MAYHEM_PIP_CAPTURE to an output directory on a graphical display for frames.
const DT := 1.0 / 60.0
var checks := 0
var failures := 0
var game: Node
var destination := OS.get_environment("MAYHEM_PIP_CAPTURE")

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, description: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(description)

func skin_check(rig: Node2D) -> void:
	var skeleton: Skeleton2D = rig.get_node("Art/Skeleton2D")
	check(skeleton.get_bone_count() == 15, "Bind skeleton has all 15 joints")
	var flexible := 0
	for mesh: Polygon2D in rig.find_children("*", "Polygon2D", true, false):
		var totals := PackedFloat32Array()
		totals.resize(mesh.polygon.size())
		var partial := false
		for b in mesh.get_bone_count():
			check(skeleton.get_node(mesh.get_bone_path(b)) is Bone2D, "Skin resolves its bone under Skeleton2D")
			var weights := mesh.get_bone_weights(b)
			for i in weights.size():
				totals[i] += weights[i]
				partial = partial or (weights[i] > 0 and weights[i] < 1)
		var normalized := true
		for w in totals:
			normalized = normalized and is_equal_approx(w, 1.0)
		check(normalized, "Weights sum to one at each vertex of " + str(mesh.name))
		if partial: flexible += 1
	check(flexible == 5, "Both arms, both legs and scarf have blended vertices")

func simulate(label: String, count: int) -> void:
	var observed := false
	for i in count:
		game._process(DT)
		observed = observed or game.view.actor.motion.pose_name == label
		if not destination.is_empty() and i % 3 == 0:
			await process_frame
			await RenderingServer.frame_post_draw
			var frame := root.get_texture().get_image()
			var crop := frame.get_region(Rect2i(354,132,252,206))
			check(crop.save_png(destination.path_join("%s-%03d.png" % [label,i])) == OK, "Save scene capture")
	check(observed, "Live session entered " + label)

func run() -> void:
	if not destination.is_empty():
		if DisplayServer.get_name() == "headless" or DirAccess.make_dir_recursive_absolute(destination) != OK:
			push_error("Captures need a graphics display and writable output directory")
			quit(1)
			return
		root.size = Vector2i(960,540)
	var app := preload("res://ui/main_menu.tscn").instantiate()
	root.add_child(app)
	current_scene = app
	await process_frame
	app.new_setup()
	app.page.select_character(MayhemCatalog.PIP_PROFILE)
	app.navigate("map")
	app.navigate("summary")
	app.commit_new()
	game = app.game
	game.set_process(false)
	# Place on a clear stretch of the actual map and move via the two input pads.
	game.sim.state = game.sim.state.duplicate(true)
	game.sim.state.player.pos = Vector2(1030,985)
	game.refresh_ui()
	game.camera.position = game.sim.state.player.pos
	if not destination.is_empty():
		await process_frame
		await RenderingServer.frame_post_draw
		check(root.get_texture().get_image().save_png(destination.path_join("gameplay.png")) == OK, "Save gameplay at default zoom")
	game.action("tutorial_skip")
	for i in 4: game.action("zoom_in")
	skin_check(game.view.actor.pip)
	var motion = game.view.actor.motion
	await simulate("idle",60)
	game.router.update_pad(0,game.router.centers[0]+Vector2(28,0))
	var start: Vector2 = game.sim.state.player.pos
	await simulate("walk",54)
	check(game.sim.state.player.pos.x > start.x+50,"Walk moves the simulated actor")
	var hips_opposed := false
	var arm_opposed := false
	for i in 18:
		game._process(DT)
		var hips: float = motion.bones[&"near_leg"].rotation
		hips_opposed = hips_opposed or hips * motion.bones[&"far_leg"].rotation < -0.01
		arm_opposed = arm_opposed or hips * motion.bones[&"near_arm"].rotation < -0.01
	check(hips_opposed and arm_opposed, "Legs alternate and the near arm counters the near leg")
	game.router.update_pad(0,game.router.centers[0]+Vector2(58,0))
	await simulate("run",48)
	game.router.clear()
	game.router.update_pad(1,game.router.centers[1]+Vector2(58,0))
	await simulate("attack",24)
	game.router.clear()
	game.router.update_pad(0,game.router.centers[0]+Vector2(58,0))
	game.action("dodge")
	await simulate("dodge",15)
	game.router.clear()
	for i in 28: game._process(DT)
	var player: Dictionary = game.sim.state.player
	var hp: float = player.hp
	EnemySystem.spawn(game.sim.state,"normal",player.pos+Vector2(24,0))
	await simulate("hit",15)
	check(player.hp < hp,"Enemy hit reduced player HP")
	app.pause_game()
	var stopped: float = motion.clock
	for i in 20: game._process(DT)
	check(motion.clock == stopped,"Pause freezes the visual clock")
	app.resume_game()
	player.slot = 0
	player.shot_cd = 0
	game.router.update_pad(1,game.router.centers[1]+Vector2(58,0))
	for i in 24: game._process(DT)
	check(motion.strike_time < 0.0 and player.shot_cd == 0,"Unarmed empty slot cannot trigger a ranged pose")
	game.router.clear()
	app.save_and_home()
	app.resume_saved()
	game = app.game
	game.set_process(false)
	check(game.view.actor.pip.visible and game.view.actor.motion.strike_time < 0, "Save restore rebinds Pip with no phantom attack")
	game.router.update_pad(0,game.router.centers[0]+Vector2(-58,0))
	game._process(DT)
	check(game.view.actor.pip.transform.x.x < 0.0, "The left-facing rig mirrors around the feet")
	print("PIP: %d checks, %d failures" % [checks, failures])
	quit(int(failures > 0))
