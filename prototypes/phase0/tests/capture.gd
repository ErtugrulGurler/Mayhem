extends SceneTree

const Visual = preload("res://scripts/character_visual.gd")

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
	# Capture the real renderer for all idle poses and every uploaded walk frame.
	var idle_sheet := Image.create(512, 288, false, Image.FORMAT_RGBA8)
	var frames := Visual.FRAME_COUNT
	var walk_sheet := Image.create(128 * frames, 1152, false, Image.FORMAT_RGBA8)
	idle_sheet.fill(Color("648d54"))
	walk_sheet.fill(Color("648d54"))
	var viewport := SubViewport.new()
	viewport.size = Vector2i(128, 144)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.transparent_bg = true
	root.add_child(viewport)
	var player: CharacterBody2D = load("res://scenes/player.tscn").instantiate()
	player.get_node("Camera").enabled = false
	viewport.add_child(player)
	player.set_physics_process(false)
	player.position = Vector2(64, 132)
	var caption := Label.new()
	caption.position = Vector2(5, 0)
	caption.add_theme_font_size_override("font_size", 13)
	viewport.add_child(caption)
	var idle_hashes: Dictionary = {}
	var walk_hashes: Dictionary = {}
	var source_hashes: Dictionary = {}
	var source := Image.new()
	source.load_png_from_buffer(FileAccess.get_file_as_bytes(Visual.WALK_ATLAS.resource_path))
	source.convert(Image.FORMAT_RGBA8)
	var directions := ["E", "SE", "S", "SW", "W", "NW", "N", "NE"]
	for index in range(8 + 8 * frames):
		var direction_index: int = index if index < 8 else (index - 8) / frames
		var frame: int = -1 if index < 8 else (index - 8) % frames
		var direction := Vector2.from_angle(direction_index * PI / 4.0)
		player.visual.update_motion(0, direction, 0)
		if frame >= 0: player.visual.update_motion(1, direction, (frame + 0.001) / Visual.ANIMATION_FPS)
		caption.text = directions[direction_index] + (" / idle" if frame < 0 else " / %d" % (frame + 1))
		await process_frame
		await RenderingServer.frame_post_draw
		var pose := viewport.get_texture().get_image()
		pose.convert(Image.FORMAT_RGBA8)
		# Exclude captions so they cannot make identical poses look distinct.
		var body_hash := hash(pose.get_region(Rect2i(0, 25, 128, 119)).get_data())
		if frame < 0:
			idle_hashes[body_hash] = true
			idle_sheet.blend_rect(pose, Rect2i(0, 0, 128, 144), Vector2i((index % 4) * 128, (index / 4) * 144))
		else:
			if not walk_hashes.has(direction_index): walk_hashes[direction_index] = {}
			walk_hashes[direction_index][body_hash] = true
			if not source_hashes.has(direction_index): source_hashes[direction_index] = {}
			var cell := Rect2i(Vector2i(Vector2(frame, direction_index) * Visual.FRAME_SIZE), Vector2i(Visual.FRAME_SIZE))
			source_hashes[direction_index][hash(source.get_region(cell).get_data())] = true
			walk_sheet.blend_rect(pose, Rect2i(0, 0, 128, 144), Vector2i(frame * 128, direction_index * 144))
	var distinct := idle_hashes.size() == 8
	for direction_index in range(8):
		distinct = distinct and walk_hashes[direction_index].size() == source_hashes[direction_index].size()
		print("RENDER ", directions[direction_index], ": ", frames, " frame slots; source/render unique poses ", source_hashes[direction_index].size(), "/", walk_hashes[direction_index].size())
	viewport.queue_free()
	await process_frame
	var saved_idle := idle_sheet.save_png(destination.path_join("phase0-character-poses.png"))
	var saved_walk := walk_sheet.save_png(destination.path_join("phase0-walk-%d-frames.png" % (8 * frames)))
	print("RENDER: eight distinct idle poses and all ", 8 * frames, " frame slots match source pose counts: ", distinct)
	if not distinct or saved_idle != OK or saved_walk != OK:
		push_error("Pose capture/uniqueness validation failed.")
		quit(1)
		return
	quit()
