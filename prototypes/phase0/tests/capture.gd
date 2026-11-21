extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("Screenshots require a rendering display.")
		quit(1)
		return
	var destination := OS.get_environment("MAYHEM_CAPTURE_DIR")
	if destination.is_empty(): destination = "user://captures"
	DirAccess.make_dir_recursive_absolute(destination)
	for dimensions in [Vector2i(960, 540), Vector2i(1200, 540), Vector2i(960, 720)]:
		root.size = dimensions
		root.content_scale_size = Vector2i(960, 540)
		root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
		root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
		var game: Node2D = load("res://scenes/world.tscn").instantiate()
		root.add_child(game)
		await process_frame
		await process_frame
		await RenderingServer.frame_post_draw
		var image := root.get_texture().get_image()
		var path := destination.path_join("phase0-%dx%d.png" % [dimensions.x, dimensions.y])
		var result := image.save_png(path)
		print("SCREENSHOT ", path, " result ", result)
		if result != OK:
			quit(1)
			return
		game.queue_free()
		await process_frame
	# Render all eight poses and four walking phases, including the back diagonals.
	var atlas := Image.create(512, 384, false, Image.FORMAT_RGBA8)
	atlas.fill(Color("648d54"))
	var hashes: Dictionary = {}
	for index in range(12):
		var viewport := SubViewport.new()
		viewport.size = Vector2i(128, 128)
		viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		viewport.transparent_bg = true
		root.add_child(viewport)
		var player: CharacterBody2D = load("res://scenes/player.tscn").instantiate()
		player.get_node("Camera").enabled = false
		viewport.add_child(player)
		player.set_physics_process(false)
		player.position = Vector2(64, 105)
		if index < 8:
			player.visual.update_motion(0, Vector2.from_angle(index * PI / 4.0), 0)
		else:
			player.visual.movement_amount = 1
			player.visual.step_phase = (index - 8) * PI / 2.0
			player.visual.update_motion(1, Vector2.DOWN, 0)
		await process_frame
		await RenderingServer.frame_post_draw
		var pose := viewport.get_texture().get_image()
		if index < 8: hashes[hash(pose.get_data())] = true
		pose.convert(Image.FORMAT_RGBA8)
		atlas.blend_rect(pose, Rect2i(0, 0, 128, 128), Vector2i((index % 4) * 128, (index / 4) * 128))
		viewport.queue_free()
		await process_frame
	if hashes.size() != 8:
		push_error("Eight facing poses must all have distinct rendered pixels.")
		quit(1)
		return
	var saved := atlas.save_png(destination.path_join("phase0-character-poses.png"))
	print("Eight distinct rendered facing poses; atlas save result ", saved)
	if saved != OK:
		quit(1)
		return
	quit()
