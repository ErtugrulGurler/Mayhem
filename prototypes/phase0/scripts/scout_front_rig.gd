extends Node2D
## Cutout animation using the uploaded, unmodified soldier pixels.
## All pivots are in the source 176x264 canvas. Parent owns facing and motion time.

const WORLD_HEIGHT := 91.0
const CANVAS_SIZE := Vector2(176, 264)
const ORIGINAL: Texture2D = preload("res://assets/characters/scout_front_rig/front_original_exact.png")
const PART_NAMES := ["backpack_left", "backpack_right", "leg_left", "leg_right", "torso", "arm_left", "arm_right", "head"]
const PIVOTS := {
	"head": Vector2(88, 119), "torso": Vector2(88, 171),
	"arm_left": Vector2(49, 139), "arm_right": Vector2(126, 139),
	"leg_left": Vector2(66, 183), "leg_right": Vector2(109, 183),
	"backpack_left": Vector2(43, 109), "backpack_right": Vector2(136, 109),
}
const OFFSETS := {
	"head": Vector2(29, 9), "torso": Vector2(60, 117),
	"arm_left": Vector2(27, 126), "arm_right": Vector2(115, 134),
	"leg_left": Vector2(38, 177), "leg_right": Vector2(89, 176),
	"backpack_left": Vector2(31, 97), "backpack_right": Vector2(118, 97),
}
const DEPTHS := {"head": 30, "torso": 15, "arm_left": 20, "arm_right": 20, "leg_left": 10, "leg_right": 10, "backpack_left": 5, "backpack_right": 5}
const TEXTURES := {
	"head": preload("res://assets/characters/scout_front_rig/head.png"),
	"torso": preload("res://assets/characters/scout_front_rig/torso.png"),
	"arm_left": preload("res://assets/characters/scout_front_rig/arm_left.png"),
	"arm_right": preload("res://assets/characters/scout_front_rig/arm_right.png"),
	"leg_left": preload("res://assets/characters/scout_front_rig/leg_left.png"),
	"leg_right": preload("res://assets/characters/scout_front_rig/leg_right.png"),
	"backpack_left": preload("res://assets/characters/scout_front_rig/backpack_left.png"),
	"backpack_right": preload("res://assets/characters/scout_front_rig/backpack_right.png"),
}
var parts: Dictionary = {}
var artwork: Node2D

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	artwork = Node2D.new()
	artwork.name = "Artwork"
	artwork.scale = Vector2.ONE * (WORLD_HEIGHT / CANVAS_SIZE.y)
	add_child(artwork)
	for part_name in PART_NAMES:
		var joint := Node2D.new()
		joint.name = part_name
		joint.position = PIVOTS[part_name]
		# PART_NAMES follows the manifest's back-to-front depth order. Keep z=0
		# so individual limbs cannot escape the player's world y-sort group.
		joint.set_meta("source_depth", DEPTHS[part_name])
		artwork.add_child(joint)
		var sprite := Sprite2D.new()
		sprite.name = "Sprite"
		sprite.texture = TEXTURES[part_name]
		sprite.centered = false
		sprite.position = OFFSETS[part_name] - PIVOTS[part_name]
		joint.add_child(sprite)
		parts[part_name] = joint
	apply_pose(0, 0)

func apply_pose(amount: float, phase: float) -> void:
	if not is_instance_valid(artwork): return
	var strength := clampf(amount, 0, 1)
	var step := sin(phase) * strength
	# Reset every pivot so a direction change or stop never leaves residual offsets.
	for part_name in PART_NAMES:
		var joint: Node2D = parts[part_name]
		joint.position = PIVOTS[part_name]
		joint.rotation = 0
	parts["leg_left"].rotation = 0.17 * step
	parts["leg_right"].rotation = -0.17 * step
	parts["arm_left"].rotation = -0.12 * step
	parts["arm_right"].rotation = 0.12 * step
	parts["head"].position.y -= absf(step) * 1.1
	parts["head"].rotation = 0.025 * step
	for part_name in ["backpack_left", "backpack_right"]:
		parts[part_name].position.y -= absf(step) * 0.6
	artwork.position = Vector2(-CANVAS_SIZE.x * artwork.scale.x * 0.5, -WORLD_HEIGHT - absf(step) * 0.35)
