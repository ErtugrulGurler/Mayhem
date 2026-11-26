extends SceneTree
## Verify every region against the uploaded standalone PNGs, plus playback rules.

const Visual = preload("res://scripts/character_visual.gd")
const ASSETS := "res://assets/characters/mayhem_soldier/"
const DIRECTIONS := ["E", "SE", "S", "SW", "W", "NW", "N", "NE"]
var checks := 0
var failures := 0

func check(condition: bool, description: String) -> void:
	checks += 1
	if condition: print("PASS ", description)
	else:
		failures += 1
		push_error(description)

func image(file_name: String) -> Image:
	var value := Image.new()
	value.load_png_from_buffer(FileAccess.get_file_as_bytes(ASSETS + file_name))
	value.convert(Image.FORMAT_RGBA8)
	return value

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(ASSETS + "manifest.json"))
	var walk := image("mayhem_walk_8dir_8f.png")
	var idle := image("mayhem_idle_8dir.png")
	check(walk.get_size() == Vector2i(2048, 2304), "Walk atlas is eight columns and eight rows")
	check(idle.get_size() == Vector2i(2048, 288), "Idle atlas is eight columns")
	var digest := HashingContext.new()
	digest.start(HashingContext.HASH_SHA256)
	digest.update(walk.get_data())
	check(digest.finish().hex_encode() == "e27ca4aa17a68f4a24802607fa2bac39c56623862003c957b298a2f458fa50aa", "Original walk atlas RGBA hash matches uploaded source")
	check(Vector2(manifest.pivot_px[0], manifest.pivot_px[1]) == Vector2(128, 272), "Uploaded foot anchor preserved")
	check(is_equal_approx(Visual.FRAME_DURATION, manifest.frame_duration_seconds), "Playback preserves the uploaded 95 ms frame duration")

	var visual := Visual.new()
	root.add_child(visual)
	check(visual.get_child_count() == 1 and visual.sprite is Sprite2D, "Exactly one renderer; no placeholder or old front rig")
	check(visual.sprite.texture_filter == CanvasItem.TEXTURE_FILTER_LINEAR and visual.sprite.region_filter_clip_enabled, "Smooth filtering with atlas-region bleed protection")
	check(visual.sprite.z_index == 0 and visual.z_index == 0, "Sprite remains inside player y-sort group")
	var nodes := visual.get_child_count()
	for direction_index in range(8):
		var direction_name: String = DIRECTIONS[direction_index]
		var direction := Vector2.from_angle(direction_index * PI / 4.0)
		check(manifest.direction_index[str(direction_index)] == direction_name, direction_name + " matches supplied direction order")
		visual.update_motion(0, direction, 0)
		var idle_rect := Rect2i(direction_index * 256, 0, 256, 288)
		check(idle.get_region(idle_rect).get_data() == image("idle_" + direction_name + ".png").get_data(), direction_name + " idle pixels match uploaded standalone pose")
		check(visual.facing_index == direction_index and visual.sprite.texture == Visual.IDLE_ATLAS and visual.sprite.region_rect == Rect2(idle_rect), direction_name + " selects correct idle region")
		var frame_hashes: Dictionary = {}
		check(idle.get_region(idle_rect).get_data() == walk.get_region(Rect2i(0, direction_index * 288, 256, 288)).get_data(), direction_name + " idle is the first walk frame")
		for frame in range(8):
			var rect := Rect2i(frame * 256, direction_index * 288, 256, 288)
			var expected := image("frames/%s/%02d.png" % [direction_name, frame])
			var pixels := walk.get_region(rect).get_data()
			check(pixels == expected.get_data(), "%s frame %d matches uploaded standalone PNG" % [direction_name, frame])
			var used := expected.get_used_rect()
			check(used.has_area() and used.position.x > 0 and used.position.y > 0 and used.end.x < 256 and used.end.y < 288, "%s frame %d is nonempty with transparent padding on every edge" % [direction_name, frame])
			frame_hashes[hash(pixels)] = true
			visual.update_motion(0, direction, 0)
			visual.update_motion(1, direction, (frame + 0.001) * 0.095)
			if direction_index == 0:
				var right_index := floori(fposmod((frame+0.001)*0.095*Visual.TEST_FPS,4))
				var right_rect := Rect2(Vector2(right_index%2,right_index/2)*627,Vector2(627,627))
				check(visual.sprite.texture == visual.right_walk_test and visual.sprite.region_rect == right_rect,"E uses the independently timed four-frame PNG at legacy clock sample %d"%frame)
				check((visual.sprite.position+visual.right_feet[right_index]*visual.sprite.scale).is_zero_approx(),"E source sole remains at origin at sample %d"%frame)
			else:
				check(visual.sprite.texture == Visual.WALK_ATLAS and visual.sprite.region_rect == Rect2(rect), "%s frame %d selected for actual rendering" % [direction_name, frame])
				check((visual.sprite.position + Vector2(128, 272) * visual.sprite.scale).is_zero_approx(), "%s frame %d keeps foot at player origin" % [direction_name, frame])
		# The supplied N/00 and N/04 are identical; keep both timed slots.
		check(frame_hashes.size() == (7 if direction_name == "N" else 8), direction_name + " preserves the supplied number of distinct poses")
		visual.update_motion(0, Vector2.ZERO, 0.01)
		check(not visual.walking and visual.frame_index == 0 and visual.animation_phase == 0 and visual.facing_index == direction_index and visual.sprite.region_rect == Rect2(idle_rect), direction_name + " stop selects matching idle, retains facing and resets phase")

	visual.update_motion(0, Vector2.RIGHT, 0)
	var sequence: Array[int] = []
	for i in range(8):
		visual.update_motion(1, Vector2.RIGHT, 0.095)
		sequence.append(visual.frame_index)
	check(sequence == [1, 2, 3, 4, 5, 6, 7, 0], "Legacy eight-frame clock remains intact alongside the right-walk clock")
	visual.update_motion(0, Vector2.ZERO, 0)
	visual.update_motion(0.5, Vector2.RIGHT, 0.095)
	check(visual.frame_index == 0, "Half speed waits twice as long for a frame")
	visual.update_motion(0.5, Vector2.RIGHT, 0.095)
	check(visual.frame_index == 1, "Half speed advances after 190 ms")
	visual.update_motion(0, Vector2.LEFT, 0)
	visual.update_motion(1, Vector2.LEFT, 0.095)
	var phase: float = visual.animation_phase
	visual.update_motion(1, Vector2.UP, 0)
	check(visual.facing_index == 6 and visual.animation_phase == phase and visual.sprite.region_rect.position.y == 1728, "Moving direction changes row without restarting stride")
	visual.update_motion(0, Vector2.LEFT, 0)
	check(visual.facing_index == 4 and visual.sprite.region_rect.position == Vector2(1024, 0), "Stationary aiming rotates the matching idle pose")
	visual.update_motion(1, Vector2.ZERO, 1000)
	check(visual.frame_index >= 0 and visual.frame_index < 8, "Long delta remains inside walk atlas")
	phase = visual.animation_phase
	visual.update_motion(1, Vector2.ZERO, -1)
	check(visual.animation_phase == phase, "Negative delta cannot reverse animation")
	visual.update_motion(-1, Vector2.ZERO, 1)
	check(not visual.walking, "Negative speed selects idle")
	for i in range(100): visual.update_motion(2, Vector2.DOWN, 0.016)
	check(visual.movement_amount == 1 and visual.get_child_count() == nodes, "Speed is clamped and playback reuses one sprite")
	visual.queue_free()
	await process_frame
	print("SOLDIER ATLAS: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
