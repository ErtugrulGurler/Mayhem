extends SceneTree
## Retained front-cutout asset/component regression; active player uses atlas now.

const Rig = preload("res://scripts/scout_front_rig.gd")
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

	var rig := Rig.new()
	root.add_child(rig)
	check(rig.parts.size() == 8, "All eight cutout joints loaded")
	check(is_equal_approx(rig.artwork.scale.x, 91.0 / 264.0), "Reference world height is 91 units")
	check(rig.artwork.position.is_equal_approx(Vector2(-88 * 91.0 / 264.0, -91)), "Reference center and foot alignment preserved")
	for part_name in Rig.PART_NAMES:
		var joint: Node2D = rig.parts[part_name]
		check(joint.z_index == 0, part_name + " stays in player world y-sort group")
		var source_pivot: Array = manifest.parts[part_name].pivot
		check(joint.position == Vector2(source_pivot[0], source_pivot[1]), part_name + " uses manifest pivot")

	rig.apply_pose(1, PI / 2)
	check(absf(rig.parts.leg_left.rotation) > 0.01, "Forward movement animates a real cutout leg")
	check(is_equal_approx(rig.parts.leg_left.rotation, -rig.parts.leg_right.rotation), "Short leg steps alternate")
	check(rig.parts.arm_left.rotation * rig.parts.leg_left.rotation < 0, "Arms counter-swing against legs")
	check(absf(rig.parts.head.rotation) <= 0.025001 and rig.parts.head.position.y < Rig.PIVOTS.head.y, "Head bounce and sway stay subtle")
	rig.apply_pose(0, PI / 2)
	var restored := true
	for part_name in Rig.PART_NAMES:
		var joint: Node2D = rig.parts[part_name]
		restored = restored and joint.position == Rig.PIVOTS[part_name] and is_zero_approx(joint.rotation)
	check(restored, "All pivots and rotations return exactly to their original rest pose")
	check(is_equal_approx(rig.artwork.position.y, -91), "No residual body bob at rest")
	var child_count: int = rig.get_child_count()
	for i in range(120): rig.apply_pose(1, i / 60.0)
	check(rig.get_child_count() == child_count and rig.parts.size() == 8, "Animation reuses nodes and textures")
	rig.queue_free()
	await process_frame
	print("SOLDIER RIG: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
