extends SceneTree
var failures := 0
func _initialize() -> void:
	call_deferred("run")
func verify(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)
	else:
		print("PASS: ", message)
func run() -> void:
	var game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game.gold = 1000
	for pair in [[0, "archer"], [2, "mage"], [6, "cannon"]]:
		game.site_buttons[pair[0]].pressed.emit()
		game.hud.build_buttons[pair[1]].pressed.emit()
	verify(game.towers[0].kind == "archer" and game.towers[2].kind == "mage" and game.towers[6].kind == "cannon", "UI buttons construct the correct tower types")
	var shot_count := [0]
	for tower in game.towers.values():
		tower.fired.connect(func(_tower, _enemy): shot_count[0] += 1)
	var initial_gold: int = game.gold
	game.hud.wave_button.pressed.emit()
	Engine.time_scale = 10.0
	var elapsed := 0.0
	while game.director.active and elapsed < 65.0:
		await create_timer(0.1).timeout
		elapsed += 0.1
	Engine.time_scale = 1.0
	verify(shot_count[0] > 0, "Towers automatically acquire enemies and fire")
	verify(game.gold > initial_gold, "Real-time projectiles kill enemies and award gold")
	verify(not game.director.active, "A full wave resolves through real-time gameplay")
	verify(game.lives > 0 and not game.game_over, "First wave is survivable")
	print("COMBAT TEST FAILURES: ", failures)
	quit(0 if failures == 0 else 1)
