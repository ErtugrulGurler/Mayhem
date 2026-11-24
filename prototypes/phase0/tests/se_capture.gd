extends SceneTree
## Native Godot frames. The floor scrolls at the calibrated root speed so
## planted-foot contact can be inspected instead of hiding it on a flat backdrop.
const Rig = preload("res://scripts/se_walk_rig.gd")
const World = preload("res://scenes/world.tscn")
const SAMPLES := 24
const ZOOM := 1.25

class FloorView:
	extends Node2D
	var phase := 0.0
	var foot_positions: Array[Vector2] = []
	func _draw() -> void:
		var tile := Rig.STRIDE/Rig.STANCE*Rig.SE.x*ZOOM
		var shift := -Vector2.ONE*tile*phase
		for y in range(-2,12):
			for x in range(-2,12):
				var tint := Color("3f604b") if (x+y)%2==0 else Color("456751")
				draw_rect(Rect2(Vector2(x,y)*tile+shift,Vector2.ONE*tile+Vector2.ONE),tint)
		for point in foot_positions:
			draw_set_transform(point,0,Vector2(1,0.24))
			draw_circle(Vector2.ZERO,21,Color(0.08,0.14,0.10,0.26))
		draw_set_transform(Vector2.ZERO)

func _initialize() -> void: call_deferred("run")

func run() -> void:
	if DisplayServer.get_name()=="headless":
		push_error("SE capture requires a rendering display")
		quit(1)
		return
	var destination := OS.get_environment("MAYHEM_CAPTURE_DIR")
	if destination.is_empty(): destination="user://se-captures"
	for directory in [destination,destination.path_join("frames"),destination.path_join("debug"),destination.path_join("alpha"),destination.path_join("gameplay")]:
		DirAccess.make_dir_recursive_absolute(directory)
	root.size=Vector2i(960,540)
	root.content_scale_size=Vector2i(960,540)
	var viewport := SubViewport.new()
	viewport.size=Vector2i(384,480)
	viewport.render_target_update_mode=SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	var floor_view := FloorView.new()
	viewport.add_child(floor_view)
	var rig := Rig.new()
	viewport.add_child(rig)
	rig.scale=Vector2.ONE*ZOOM
	rig.position=Vector2(192,440)-Rig.ORIGIN*ZOOM
	var title := Label.new()
	title.position=Vector2(16,12)
	title.add_theme_font_size_override("font_size",15)
	viewport.add_child(title)
	var sheet := Image.create(2304,1920,false,Image.FORMAT_RGBA8)
	for debug in [false,true]:
		rig.debug_visible=debug
		for frame in range(SAMPLES):
			var u := float(frame)/SAMPLES
			rig.sample_cycle(u)
			floor_view.phase=u
			floor_view.foot_positions.clear()
			for index in range(2):
				var foot := rig.last_feet[index]
				var leg_phase := fposmod(u+index*0.5,1)
				if leg_phase >= Rig.STANCE:
					foot.y += pow(sin(PI*(leg_phase-Rig.STANCE)/(1-Rig.STANCE)),2)*Rig.LIFT
				floor_view.foot_positions.append(rig.position+foot*ZOOM)
			floor_view.queue_redraw()
			title.text="SE / joints + contact" if debug else "SE / walk pace: 40 units/s"
			await process_frame
			await process_frame
			await RenderingServer.frame_post_draw
			var image := viewport.get_texture().get_image()
			var folder := "debug" if debug else "frames"
			var result := image.save_png(destination.path_join("%s/%03d.png"%[folder,frame]))
			if result != OK:
				push_error("Failed to save SE frame")
				quit(1)
				return
			if not debug: sheet.blit_rect(image,Rect2i(0,0,384,480),Vector2i((frame%6)*384,(frame/6)*480))
	sheet.save_png(destination.path_join("se-contact-sheet.png"))
	viewport.transparent_bg=true
	floor_view.visible=false
	title.visible=false
	rig.debug_visible=false
	for frame in range(SAMPLES):
		rig.sample_cycle(float(frame)/SAMPLES)
		await process_frame
		await RenderingServer.frame_post_draw
		viewport.get_texture().get_image().save_png(destination.path_join("alpha/%03d.png"%frame))
	viewport.queue_free()
	await process_frame
	var game := World.instantiate()
	root.add_child(game)
	current_scene=game
	await process_frame
	Input.action_press("move_right")
	Input.action_press("move_down")
	for frame in range(90):
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(destination.path_join("gameplay/%03d.png"%frame))
	Input.action_release("move_right")
	Input.action_release("move_down")
	print("SE CAPTURE: 24 continuous-cycle samples, 24 joint/contact samples, 90 real gameplay frames")
	print("SE METRIC natural preview cycle: ",Rig.STRIDE*Rig.ART_SCALE/(40*Rig.STANCE)," s; unchanged full-speed cycle: ",Rig.STRIDE*Rig.ART_SCALE/(220*Rig.STANCE)," s")
	game.queue_free()
	await process_frame
	quit()
