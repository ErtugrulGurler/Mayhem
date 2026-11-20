extends SceneTree
var game: Node
func _initialize() -> void: call_deferred("run")
func snap(name: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	var result := root.get_texture().get_image().save_png("res://docs/ux/"+name+".png")
	print("CAPTURE ",name," exit ",result," viewport ",root.get_visible_rect().size)
func run() -> void:
	game=load("res://prototype/scenes/session.tscn").instantiate()
	root.add_child(game)
	current_scene=game
	await process_frame
	game.set_process(false)
	await snap("01-menu")
	game.action("new")
	game._process(0)
	await snap("02-first-task")
	for requested in [Vector2i(1200,540),Vector2i(960,720)]:
		root.size=requested
		await create_timer(0.4).timeout
		game.refresh_ui()
		await snap("02-task-%dx%d" % [requested.x,requested.y])
	root.size=Vector2i(960,540)
	await create_timer(0.4).timeout
	game.refresh_ui()
	game.hud.show_panel("build")
	await snap("03-build-panel")
	game.hud.choose_building("smelter")
	game._process(0)
	await snap("04-placement")
	game.place_at(game.ghost)
	game.hud.show_panel("inventory")
	await snap("05-inventory")
	game.hud.close_panel()
	# Visual fixture only: illustrate silhouettes and stopped/damaged state, not gameplay evidence.
	game.sim.state.tutorial.skipped=true
	var positions=[Vector2(450,600),Vector2(600,500),Vector2(740,600),Vector2(450,740),Vector2(740,760)]
	var kinds=["depot","smelter","ammo_bench","clinic","turret"]
	game.sim.state.structures.clear()
	for i in range(kinds.size()):
		var b:=MayhemCatalog.building(kinds[i],positions[i],MayhemState.next_id(game.sim.state))
		b.built=true
		if i==1: b.hp=45
		game.sim.state.structures.append(b)
	game.sim.state.player.pos=Vector2(740,665)
	game.camera.position=Vector2(620,640)
	game.camera.zoom=Vector2.ONE*1.0
	game.selection={"type":"building","data":game.sim.state.structures[2]}
	game.refresh_ui()
	await snap("06-readable-objects")
	for requested in [Vector2i(1200,540),Vector2i(960,720)]:
		root.size=requested
		await create_timer(0.4).timeout
		await process_frame
		game.refresh_ui()
		await snap("07-ratio-%dx%d" % [requested.x,requested.y])
	quit()
