extends SceneTree
var failures := 0
var checks := 0
var arena: Node
var destination := OS.get_environment("MAYHEM_PLAYGROUND_FRAMES")
func check(ok: bool, msg: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(msg)
func _initialize() -> void: call_deferred("run")
func run() -> void:
	root.size = Vector2i(960,540)
	var menu := load("res://ui/main_menu.tscn").instantiate() as Node
	root.add_child(menu)
	current_scene = menu
	menu.page.buttons.new.pressed.emit()
	await scene_changed
	arena = current_scene
	check(arena.name=="CombatPlayground","New game launches training directly")
	arena.set_physics_process(false)
	var origin: Vector2 = arena.player.position
	var aim: Vector2 = origin.direction_to(arena.bag.pos)
	for i in 15: arena.step(1.0/60,Vector2.ZERO,aim)
	check(arena.shots==0 and arena.state.projectiles.is_empty(),"Empty hand only faces")
	for slot in [1,2,3]:
		arena.equip(slot)
		if slot==3: arena.player.position=arena.bag.pos-aim*42
		var total: float = arena.bag.total
		for i in 80:
			arena.step(1.0/60,Vector2.ZERO,aim)
			if not destination.is_empty() and i>=20 and i%3==0:
				await process_frame
				await RenderingServer.frame_post_draw
				var center := Vector2i(arena.player.get_global_transform_with_canvas().origin)
				var image := root.get_texture().get_image().get_region(Rect2i(center-Vector2i(65,88),Vector2i(216,145)))
				check(image.save_png(destination.path_join("gear-%d-%02d.png"%[slot,i]))==OK,"Capture equipped strike")
		check(arena.bag.total>total and arena.state.enemies.size()==1,"Weapon damages persistent dummy")
		var count: int = arena.shots
		for i in 60: arena.step(1.0/60,Vector2.ZERO,Vector2.ZERO)
		check(arena.shots==count,"Release stops attacks")
	arena.equip(0)
	arena.player.position = origin
	arena.step(1.0/60,Vector2.LEFT,Vector2.RIGHT)
	check(arena.player.velocity.x<0 and arena.motion.skin.sector==0,"Strafe independently")
	arena.step(1.0/60,Vector2.ZERO,Vector2.RIGHT.rotated(deg_to_rad(24)))
	check(arena.motion.skin.sector==0,"Hysteresis holds at sector edge")
	var phase: float = arena.motion.gaits.phase
	arena.step(1.0/60,Vector2.LEFT,Vector2.UP)
	check(arena.motion.gaits.phase>=phase,"Turn preserves gait clock")
	for sector in 8:
		var heading := Vector2.RIGHT.rotated(sector*TAU/8)
		arena.motion.advance(0.5,Vector2.ZERO,heading,false,false,false,false)
		check(arena.motion.skin.sector==sector and arena.motion.pose_name=="idle","Directional idle")
		arena.player.position = origin
		arena.player.velocity = Vector2.ZERO
		for i in 32:
			arena.step(1.0/60,heading,Vector2.ZERO)
			if not destination.is_empty() and i%2==0:
				await process_frame
				await RenderingServer.frame_post_draw
				var img := root.get_texture().get_image()
				var center: Vector2i = Vector2i(arena.player.get_global_transform_with_canvas().origin)
				img.get_region(Rect2i(center-Vector2i(46,78),Vector2i(92,92))).save_png(destination.path_join("%d-%02d.png"%[sector,i]))
		check(arena.motion.skin.sector==sector,"Movement selects direction "+str(sector))
		arena.motion.advance(0.04,Vector2.ZERO,heading,true,false,false,false)
		check(arena.motion.pose_name=="attack","Attack pose")
		arena.motion.advance(0.04,Vector2.ZERO,heading,false,true,false,false)
		check(arena.motion.pose_name=="dodge","Dodge pose")
		arena.motion.advance(0.04,Vector2.ZERO,heading,false,false,true,false)
		check(arena.motion.pose_name=="hit","Hit pose")
	if not destination.is_empty():
		arena.equip(2)
		arena.player.position = origin
		arena.player.get_node("Camera").reset_smoothing()
		for i in 24: arena.step(1.0/60,Vector2.ZERO,aim)
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png(destination.path_join("meadow.png"))
	print("PLAYGROUND: %d checks, %d failures"%[checks,failures])
	quit(int(failures>0))
