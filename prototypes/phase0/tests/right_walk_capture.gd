extends SceneTree
## Capture the unchanged production PNG through the actual Sprite2D renderer.
const Visual = preload("res://scripts/character_visual.gd")
const World = preload("res://scenes/world.tscn")

class Baseline:
	extends Node2D
	func _draw() -> void:
		draw_line(Vector2(0,330),Vector2(384,330),Color("a3b18b"),1,true)

func _initialize() -> void: call_deferred("run")

func run() -> void:
	if DisplayServer.get_name()=="headless":
		push_error("Capture requires a rendering display")
		quit(1)
		return
	var destination := OS.get_environment("MAYHEM_CAPTURE_DIR")
	if destination.is_empty(): destination="user://right-walk-captures"
	DirAccess.make_dir_recursive_absolute(destination)
	root.size=Vector2i(960,540)
	root.content_scale_size=Vector2i(960,540)
	var viewport := SubViewport.new()
	viewport.size=Vector2i(384,360)
	viewport.render_target_update_mode=SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	viewport.add_child(Baseline.new())
	var visual := Visual.new()
	viewport.add_child(visual)
	visual.position=Vector2(192,330)
	visual.scale=Vector2.ONE*3
	if visual.right_walk_test == null:
		push_error("Original right-walk project texture was not loaded")
		quit(1)
		return
	var caption := Label.new()
	caption.position=Vector2(12,8)
	caption.add_theme_font_size_override("font_size",16)
	viewport.add_child(caption)
	var sheet := Image.create(1536,360,false,Image.FORMAT_RGBA8)
	var hashes: Dictionary = {}
	for frame in range(4):
		visual.update_motion(0,Vector2.RIGHT,0)
		visual.update_motion(1,Vector2.RIGHT,frame*0.16)
		caption.text="RIGHT / original frame %d / 6.25 FPS"%(frame+1)
		await process_frame
		await process_frame
		await RenderingServer.frame_post_draw
		var image := viewport.get_texture().get_image()
		var body := image.get_region(Rect2i(0,45,384,315))
		hashes[hash(body.get_data())]=true
		image.save_png(destination.path_join("right-frame-%d.png"%frame))
		sheet.blit_rect(image,Rect2i(0,0,384,360),Vector2i(frame*384,0))
	if hashes.size()!=4:
		push_error("Four distinct rendered poses were not observed")
		quit(1)
		return
	sheet.save_png(destination.path_join("right-contact-sheet.png"))
	viewport.queue_free()
	await process_frame
	var game := World.instantiate()
	root.add_child(game)
	current_scene=game
	game.player.position=Vector2(1000,1000)
	game.player.get_node("Camera").reset_smoothing()
	Input.action_press("move_right")
	for frame in range(40):
		await physics_frame
		await process_frame
		await RenderingServer.frame_post_draw
	Input.action_release("move_right")
	if game.player.visual.sprite.texture != game.player.visual.right_walk_test:
		push_error("Actual keyboard movement did not select the right-walk PNG")
		quit(1)
		return
	root.get_texture().get_image().save_png(destination.path_join("right-gameplay.png"))
	print("RIGHT RENDER: four original frame regions visible; actual keyboard movement uses production PNG")
	game.queue_free()
	await process_frame
	quit()
