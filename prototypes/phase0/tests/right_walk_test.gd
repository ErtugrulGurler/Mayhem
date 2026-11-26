extends SceneTree
## Geometry-only fixtures; these blocks are not replacement character artwork.
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
	visual.configure_right_walk(null)
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
