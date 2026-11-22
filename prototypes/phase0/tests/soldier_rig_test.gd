extends SceneTree
## Asset identity, cutout assembly, stop/reset and world-sorting regressions.

const Rig = preload("res://scripts/scout_front_rig.gd")
const PlayerScene = preload("res://scenes/player.tscn")
const ASSETS := "res://assets/characters/scout_front_rig/"
var checks := 0
var failures := 0

func check(condition: bool, description: String) -> void:
	checks += 1
	if condition: print("PASS ", description)
	else:
		failures += 1
		push_error(description)

func _initialize() -> void:
	call_deferred("run")

func source_image(file_name: String) -> Image:
	# Validate uploaded source bytes, before the texture importer's transparent
	# edge-color fix. Runtime sprites use preloaded textures for exported builds.
	var image := Image.new()
	image.load_png_from_buffer(FileAccess.get_file_as_bytes(ASSETS + file_name))
	image.convert(Image.FORMAT_RGBA8)
	return image

func run() -> void:
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(ASSETS + "rig_manifest.json"))
	var original := source_image("front_original_exact.png")
	check(original.get_size() == Vector2i(176, 264), "Uploaded front canvas size preserved")
	var digest := HashingContext.new()
	digest.start(HashingContext.HASH_SHA256)
	digest.update(original.get_data())
	check(digest.finish().hex_encode() == manifest.original_sha256, "Uploaded original RGBA pixel hash preserved")
	var assembled := Image.create(176, 264, false, Image.FORMAT_RGBA8)
	assembled.fill(Color(0, 0, 0, 0))
	for part_name in Rig.PART_NAMES:
		var part := source_image(part_name + ".png")
		var bounds: Array = manifest.parts[part_name].bounds
		check(part.get_size() == Vector2i(bounds[2], bounds[3]), part_name + " uses uploaded crop dimensions")
		# These cutouts partition pixels, rather than layering partial alpha. Copy
		# RGBA without blend_rect's premultiply/unpremultiply rounding at soft edges.
		assembled.blit_rect_mask(part, part, Rect2i(Vector2i.ZERO, part.get_size()), Vector2i(bounds[0], bounds[1]))
	check(assembled.get_data() == original.get_data(), "Eight uploaded cutouts reconstruct every original RGBA pixel")

	var player := PlayerScene.instantiate()
	root.add_child(player)
	player.set_physics_process(false)
	player.get_node("Camera").enabled = false
	var visual: Node2D = player.get_node("Visual")
	var rig: Node2D = visual.front_rig
	check(rig.parts.size() == 8, "All eight cutout joints loaded")
	check(is_equal_approx(rig.artwork.scale.x, 91.0 / 264.0), "Reference world height is 91 units")
	check(rig.artwork.position.is_equal_approx(Vector2(-88 * 91.0 / 264.0, -91)), "Reference center and foot alignment preserved")
	for part_name in Rig.PART_NAMES:
		var joint: Node2D = rig.parts[part_name]
		check(joint.z_index == 0, part_name + " stays in player world y-sort group")

	visual.update_motion(1, Vector2.DOWN, 0.1)
	check(rig.visible and visual.facing_index == 2, "Front direction enables the uploaded soldier")
	check(absf(rig.parts.leg_left.rotation) > 0.01, "Forward movement animates a real cutout leg")
	check(is_equal_approx(rig.parts.leg_left.rotation, -rig.parts.leg_right.rotation), "Short leg steps alternate")
	check(rig.parts.arm_left.rotation * rig.parts.leg_left.rotation < 0, "Arms counter-swing against legs")
	check(absf(rig.parts.head.rotation) <= 0.025 and rig.parts.head.position.y < Rig.PIVOTS.head.y, "Head bounce and sway stay subtle")
	for i in range(8):
		visual.update_motion(1, Vector2.from_angle(i * PI / 4.0), 0.1)
		check(rig.visible == (i == 2), "Only front uses the cutout rig: direction %d" % i)
	visual.update_motion(1, Vector2.DOWN, 0.1)
	visual.update_motion(0, Vector2.ZERO, 0.25)
	check(visual.facing_index == 2 and rig.visible, "Stopping preserves the previous facing")
	var restored := true
	for part_name in Rig.PART_NAMES:
		var joint: Node2D = rig.parts[part_name]
		restored = restored and joint.position == Rig.PIVOTS[part_name] and is_zero_approx(joint.rotation)
	check(restored, "All pivots and rotations return exactly to their original rest pose")
	check(is_equal_approx(rig.artwork.position.y, -91), "No residual body bob at rest")
	var child_count: int = rig.get_child_count()
	for i in range(120): visual.update_motion(1, Vector2.DOWN, 1.0 / 60.0)
	check(rig.get_child_count() == child_count and rig.parts.size() == 8, "Animation reuses nodes and textures")
	player.queue_free()
	await process_frame
	print("SOLDIER RIG: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
