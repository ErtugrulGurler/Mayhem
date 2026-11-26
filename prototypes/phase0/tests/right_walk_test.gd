extends SceneTree
## Original production PNG first, then geometry-only failure/fallback fixtures.
const Visual = preload("res://scripts/character_visual.gd")
var checks := 0
var failures := 0

func check(ok: bool, description: String) -> void:
	checks += 1
	if ok: print("PASS ",description)
	else:
		failures += 1
		push_error(description)

func _initialize() -> void: call_deferred("run")

func run() -> void:
	var visual := Visual.new()
	root.add_child(visual)
	var production := visual.right_walk_test
	check(production != null and production.resource_path == Visual.RIGHT_WALK_PATH,"Original PNG is loaded from the imported project resource")
	check(FileAccess.get_sha256(Visual.RIGHT_WALK_PATH) == "36e6527666b7a890685e22c1cc037b483c4201639af86ee0399cd2ca381addef","Production PNG matches uploaded bytes exactly")
	check(production.get_size() == Vector2(1254,1254) and visual.right_cell == Vector2(627,627),"Actual 1254x1254 PNG uses four 627x627 cells")
	check(is_equal_approx(visual.right_scale,0.15539568345324),"One measured scale matches existing character height")
	var measured := [Vector2(341,559),Vector2(279,568),Vector2(353.5,576),Vector2(287.5,575)]
	for frame in range(4):
		visual.update_motion(1,Vector2.RIGHT,0 if frame==0 else 0.16)
		check(visual.right_feet[frame] == measured[frame],"Real frame %d uses measured silhouette center and sole"%frame)
		check(visual.sprite.texture == production and visual.sprite.region_rect == Rect2(Vector2(frame%2,frame/2)*627,Vector2(627,627)),"Real frame %d uses its original row-major rectangle"%frame)
		check((visual.sprite.position+measured[frame]*visual.sprite.scale).is_zero_approx(),"Real frame %d is aligned at the player origin"%frame)
		check(visual.sprite.visible and visual.sprite.get_rect().has_area(),"Real frame %d remains visible"%frame)
	visual.configure_right_walk(null)
	visual.update_motion(0,Vector2.RIGHT,0)
	var repeated_scene := Visual.new()
	root.add_child(repeated_scene)
	check(repeated_scene.right_feet.size() == 4 and repeated_scene.right_feet[0] == measured[0],"Clearing one actor cannot corrupt the shared imported-texture layout")
	repeated_scene.queue_free()
	visual.update_motion(1,Vector2.RIGHT,0)
	check(visual.sprite.texture == Visual.WALK_ATLAS and visual.sprite.visible,"Missing optional PNG keeps original character visible")
	var image := Image.create(20,24,false,Image.FORMAT_RGBA8)
	image.fill(Color(0,0,0,0))
	var shapes := [Rect2i(2,1,5,10),Rect2i(2,2,6,9),Rect2i(1,1,7,9),Rect2i(3,3,4,8)]
	for i in range(4):
		var rect: Rect2i = shapes[i]
		rect.position += Vector2i(i%2,i/2)*Vector2i(10,12)
		image.fill_rect(rect,Color(0.8,0.4+i*0.1,0.3,1))
	var texture := ImageTexture.create_from_image(image)
	check(visual.configure_right_walk(texture),"Valid 2x2 geometry fixture accepted")
	check(visual.right_cell == Vector2(10,12),"Cell size is derived from actual texture dimensions")
	for frame in range(4):
		visual.update_motion(1,Vector2.RIGHT,0 if frame==0 else 0.16)
		var expected := Rect2(Vector2(frame%2,frame/2)*Vector2(10,12),Vector2(10,12))
		check(visual.sprite.texture == texture and visual.sprite.region_rect == expected,"Row-major right frame %d selected"%frame)
		check(is_zero_approx(visual.sprite.position.y+visual.right_feet[frame].y*visual.right_scale),"Measured sole lies at origin for frame %d"%frame)
		check(visual.sprite.get_rect().has_area() and visual.right_scale > 0,"Frame %d has visible geometry"%frame)
	visual.update_motion(1,Vector2.RIGHT,0.16)
	check(visual.sprite.region_rect.position == Vector2.ZERO,"Independent 6.25 FPS cycle wraps after four frames")
	for direction in range(1,8):
		visual.update_motion(0,Vector2.from_angle(direction*PI/4),0)
		visual.update_motion(1,Vector2.from_angle(direction*PI/4),0)
		check(visual.sprite.texture == Visual.WALK_ATLAS and visual.sprite.region_rect == Rect2(0,direction*288,256,288) and visual.sprite.scale == Vector2.ONE*Visual.WORLD_SCALE,"Other direction %d retains original atlas/scale"%direction)
	visual.update_motion(0,Vector2.RIGHT,0)
	check(visual.sprite.texture == Visual.IDLE_ATLAS and visual.sprite.position == -Visual.FOOT_ANCHOR*Visual.WORLD_SCALE,"Stopping restores original right idle and foot anchor")
	check(not visual.configure_right_walk(ImageTexture.create_from_image(Image.create(21,24,false,Image.FORMAT_RGBA8))),"Odd texture dimensions rejected safely")
	var empty := Image.create(20,24,false,Image.FORMAT_RGBA8)
	empty.fill(Color(0,0,0,0))
	check(not visual.configure_right_walk(ImageTexture.create_from_image(empty)),"Empty cells rejected safely")
	visual.update_motion(1,Vector2.RIGHT,0)
	check(visual.sprite.texture == Visual.WALK_ATLAS,"Invalid sheet falls back to original visible character")
	visual.queue_free()
	await process_frame
	print("RIGHT WALK: %d checks, %d failures"%[checks,failures])
	quit(1 if failures else 0)
