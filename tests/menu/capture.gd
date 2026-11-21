extends SceneTree
var app: Node
func _initialize() -> void: call_deferred("run")
func shot(name: String) -> void:
	await process_frame; await process_frame
	await RenderingServer.frame_post_draw
	var image:=root.get_texture().get_image()
	var code:=image.save_png("res://docs/menu/"+name+".png")
	print("CAPTURE ",name," ",image.get_size()," exit ",code)
func run() -> void:
	for path in ["user://suspend.bin","user://preferences.cfg","user://last_statistics.json"]:
		DirAccess.remove_absolute(path)
	app=load("res://ui/main_menu.tscn").instantiate()
	root.add_child(app); current_scene=app
	await shot("01-main-menu")
	for pressed in [true,false]:
		var event:=InputEventMouseButton.new()
		event.position=app.backdrop.core_position
		event.global_position=event.position
		event.button_index=MOUSE_BUTTON_LEFT
		event.pressed=pressed
		root.push_input(event,true)
	print("CORE TOUCH visual pulse ",app.backdrop.pulse)
	await shot("01-core-touch")
	app.new_setup()
	await shot("02-character")
	app.navigate("map")
	await shot("03-map")
	app.navigate("summary")
	await shot("04-summary")
	app.commit_new()
	app.game.set_process(false)
	app.pause_game()
	await shot("05-pause")
	app.navigate("settings")
	await shot("06-settings")
	app.back(); app.resume_game()
	await shot("07-top-down-gameplay")
	app.pause_game(); app.save_and_home()
	await shot("08-continue-enabled")
	for pixels in [Vector2i(1920,1080),Vector2i(2340,1080),Vector2i(2400,1080)]:
		root.size=pixels
		await create_timer(0.4).timeout
		await shot("09-main-%dx%d" % [pixels.x,pixels.y])
	quit()
