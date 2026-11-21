extends SceneTree
## Real Godot physics + routed synthetic pointer/keyboard events; no Android claim.

var checks := 0
var failures := 0
const WorldScene = preload("res://scenes/world.tscn")

func check(condition: bool, description: String) -> void:
	checks += 1
	if condition: print("PASS ", description)
	else:
		failures += 1
		push_error(description)

func frames(count: int) -> void:
	for i in range(count): await physics_frame

func touch(index: int, pressed: bool, point: Vector2) -> InputEventScreenTouch:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.pressed = pressed
	event.position = point
	return event

func key(code: Key, pressed: bool) -> void:
	var event := InputEventKey.new()
	event.physical_keycode = code
	event.pressed = pressed
	Input.parse_input_event(event)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var game := WorldScene.instantiate()
	root.add_child(game)
	current_scene = game
	root.size = Vector2i(960, 540)
	root.content_scale_size = Vector2i(960, 540)
	await frames(3)
	var player: CharacterBody2D = game.player
	var router: Node = game.controls
	var camera: Camera2D = player.get_node("Camera")
	check(player.position == Vector2(1200, 800), "Clear, deterministic spawn")
	check(player.motion_mode == CharacterBody2D.MOTION_MODE_FLOATING, "Top-down floating physics")
	check(player.collision_layer == 2 and player.collision_mask == 1, "Separate player/world collision layers")
	check(game.get_node("Actors").y_sort_enabled, "Ground contact y-sorting")
	check(camera.position_smoothing_enabled and camera.limit_right == 2400, "Smooth camera bounded to map")
	check(not ProjectSettings.get_setting("input_devices/pointing/emulate_mouse_from_touch"), "Touch cannot become duplicate mouse input")

	player.position = Vector2(1200, 1400)
	key(KEY_D, true)
	await frames(20)
	var start: Vector2 = player.position
	await frames(30)
	var straight_distance := player.position.distance_to(start)
	check(straight_distance > 95 and straight_distance < 125, "Physical D key drives configured movement speed")
	check(player.visual.movement_amount > 0.9 and player.visual.bob >= 0, "Real movement drives short-step animation")
	key(KEY_D, false)
	await frames(20)
	check(player.velocity.length() < 0.1, "Key release brakes to rest")
	player.position = Vector2(1200, 1400)
	key(KEY_D, true)
	key(KEY_W, true)
	await frames(20)
	start = player.position
	await frames(30)
	var diagonal_distance := player.position.distance_to(start)
	check(absf(diagonal_distance - straight_distance) < 3, "Diagonal speed equals cardinal speed")
	check(player.position.x > start.x and player.position.y < start.y, "Keyboard supports free diagonal movement")
	key(KEY_D, false)
	key(KEY_W, false)
	await frames(20)
	check(player.visual.movement_amount < 0.02, "Idle settles without walking in place")

	for i in range(8):
		var direction := Vector2.from_angle(i * PI / 4.0)
		player.visual.update_motion(1, direction, 0.1)
		check(player.visual.facing_index == i, "Eight-direction pose %d" % i)

	player.position = Vector2(1160, 776)
	player.velocity = Vector2.ZERO
	key(KEY_A, true)
	await frames(65)
	check(player.position.x > 1070 and player.position.x < 1100, "Rock footprint blocks the player")
	key(KEY_A, false)
	await frames(10)
	player.position = Vector2(1120, 620)
	player.velocity = Vector2.ZERO
	key(KEY_W, true)
	await frames(65)
	check(player.position.y > 545, "Tree trunk footprint blocks the player")
	key(KEY_W, false)
	await frames(10)
	player.position = Vector2(45, 800)
	player.velocity = Vector2.ZERO
	key(KEY_A, true)
	await frames(40)
	check(player.position.x >= 32, "World boundary prevents walking out")
	key(KEY_A, false)
	await frames(10)

	player.position = Vector2(1200, 800)
	player.velocity = Vector2.ZERO
	camera.reset_smoothing()
	await frames(3)
	var old_camera := camera.get_screen_center_position()
	player.position += Vector2(160, 0)
	await frames(3)
	var early_camera := camera.get_screen_center_position()
	check(early_camera.x > old_camera.x and early_camera.x < player.position.x - 10, "Camera follows gradually rather than snapping")
	await frames(50)
	check(absf(camera.get_screen_center_position().x - player.position.x) < 8, "Camera converges to player position")

	var left: Control = router.move_stick
	var right: Control = router.aim_stick
	# Send through the real viewport input pipeline, not directly to the router.
	Input.parse_input_event(touch(11, true, left.center() + Vector2(45, 0)))
	Input.parse_input_event(touch(22, true, right.center() + Vector2(0, -45)))
	await frames(3)
	check(router.owners.size() == 2, "Two concurrent touch IDs captured independently")
	check(router.movement().x > 0.5 and router.aim(Vector2.ZERO).y < -0.5, "Movement and facing can be controlled simultaneously")
	check(player.facing_direction.y < -0.9, "Right stick rotates the actual character")
	Input.parse_input_event(touch(11, false, Vector2(-100, -100)))
	await frames(2)
	check(router.movement().is_zero_approx() and right.active, "Offscreen release clears only the owning stick")
	var drag := InputEventScreenDrag.new()
	drag.index = 22
	drag.position = right.center() + Vector2(200, 0)
	Input.parse_input_event(drag)
	await frames(2)
	check(is_equal_approx(router.aim(Vector2.ZERO).length(), 1.0), "Dragging outside the stick clamps magnitude")
	Input.parse_input_event(touch(22, false, drag.position))
	Input.parse_input_event(touch(33, true, Vector2(480, 200)))
	await frames(2)
	check(router.owners.is_empty(), "World touches do not capture invisible joysticks")
	Input.parse_input_event(touch(33, false, Vector2(480, 200)))
	Input.parse_input_event(touch(44, true, left.center() + Vector2(1, 1)))
	await frames(2)
	check(router.movement().is_zero_approx(), "Joystick center has a stable dead zone")
	var cancellation := touch(44, true, left.center())
	cancellation.canceled = true
	Input.parse_input_event(cancellation)
	await frames(2)
	check(not left.active and router.owners.is_empty(), "OS-canceled touch releases its joystick")
	Input.parse_input_event(touch(55, true, left.center() + Vector2(45, 0)))
	await frames(2)
	router._notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	check(not left.active and not right.active and router.owners.is_empty(), "Focus loss releases all pointers")

	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_RIGHT
	click.pressed = true
	click.position = Vector2(900, 200)
	Input.parse_input_event(click)
	await frames(2)
	check(router.mouse_aiming and not player.aim_input.is_zero_approx(), "Right mouse provides desktop facing")
	click.pressed = false
	Input.parse_input_event(click)
	await frames(2)
	check(not router.mouse_aiming, "Right mouse releases cleanly")
	var left_click := InputEventMouseButton.new()
	left_click.button_index = MOUSE_BUTTON_LEFT
	left_click.pressed = true
	left_click.position = left.center() + Vector2(-40, 0)
	Input.parse_input_event(left_click)
	await frames(2)
	check(router.movement().x < -0.4, "Mouse can exercise the mobile stick")
	left_click.pressed = false
	Input.parse_input_event(left_click)
	await frames(2)
	check(not left.active, "Mouse stick releases cleanly")
	key(KEY_UP, true)
	await frames(2)
	check(router.movement().y < 0, "Arrow key mapping works")
	key(KEY_UP, false)
	await frames(2)

	game.queue_free()
	await process_frame
	for dimensions in [Vector2i(960, 540), Vector2i(1200, 540), Vector2i(960, 720), Vector2i(1280, 800), Vector2i(1920, 1080), Vector2i(2400, 1080)]:
		var viewport := SubViewport.new()
		viewport.size = dimensions
		root.add_child(viewport)
		var scene := WorldScene.instantiate()
		viewport.add_child(scene)
		await process_frame
		await process_frame
		var hud: CanvasLayer = scene.get_node("HUD")
		hud.relayout()
		var bounds := Rect2(Vector2.ZERO, Vector2(dimensions))
		var controls: Array[Control] = [hud.header, hud.hint, hud.move_stick, hud.aim_stick, hud.move_label, hud.aim_label, hud.root.get_node("ControlsNote")]
		var inside := true
		var overlapping := false
		for control in controls:
			inside = inside and bounds.encloses(control.get_global_rect())
		for i in range(controls.size()):
			for j in range(i + 1, controls.size()):
				if controls[i].get_global_rect().intersects(controls[j].get_global_rect()):
					overlapping = true
		check(inside, "HUD stays in bounds at " + str(dimensions))
		check(not overlapping, "HUD regions stay separate at " + str(dimensions))
		check(hud.move_stick.radius() * 2 > 100, "Large touch targets at " + str(dimensions))
		viewport.queue_free()
		await process_frame
	print("PHASE 0: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
