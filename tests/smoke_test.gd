extends SceneTree
## Integration tests exercise real scene objects and signals, without external addons.
var failures := 0

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)
	else:
		print("PASS: ", message)

func clear_enemies() -> void:
	for enemy in get_nodes_in_group("enemies"):
		enemy.queue_free()
	await process_frame

func run() -> void:
	var scene := load("res://scenes/main.tscn") as PackedScene
	var game = scene.instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	game.set_process(false)
	game.director.set_process(false)
	check(game.gold == 240 and game.lives == 20, "Session starts with 240 gold and 20 lives")
	check(game.site_buttons.size() == 9, "Nine build sites available")
	for pair in [[0, "archer"], [1, "mage"]]:
		game.select_site(pair[0])
		game.build_tower(pair[1])
	check(game.towers.size() == 2 and game.gold == 70, "Builds two distinct towers and debits costs")
	game.select_site(2)
	game.build_tower("cannon")
	check(game.towers.size() == 2 and game.gold == 70, "Cannot build without enough gold")
	game.gold = 1000
	game.build_tower("cannon")
	game.build_tower("archer")
	check(game.towers.size() == 3, "Cannot overwrite an occupied site")
	var tower: Tower = game.towers[2]
	var damage_before := tower.stat("damage")
	game.upgrade_tower()
	game.upgrade_tower()
	var before: int = game.gold
	game.upgrade_tower()
	check(tower.level == 3 and game.gold == before and tower.stat("damage") > damage_before, "Upgrades improve damage and cap at level 3")
	for item in game.towers.values():
		item.set_process(false)
	for kind in ["normal", "runner", "tank"]:
		game.spawn_enemy(kind, 3)
	check(get_nodes_in_group("enemies").size() == 3, "All three enemy types instantiate")
	var enemies := get_nodes_in_group("enemies")
	var first: Enemy = enemies[0]
	first.set_process(false)
	first.position = Vector2(400, 250)
	var second: Enemy = enemies[1]
	second.set_process(false)
	second.position = Vector2(410, 250)
	var third: Enemy = enemies[2]
	third.set_process(false)
	third.position = Vector2(800, 250)
	var gold_before: int = game.gold
	first.take_damage(10000)
	first.take_damage(10000)
	check(game.gold == gold_before + first.reward, "A kill grants its reward exactly once")
	await process_frame
	var hp_before := second.health
	var tank_hp := third.health
	var shot := Projectile.new()
	shot.position = second.position
	shot.last_position = second.position
	shot.target = second
	shot.splash = 65
	shot.damage = 10
	game.add_child(shot)
	shot._process(0.01)
	check(second.health == hp_before - 10 and third.health == tank_hp, "Cannon splash affects only nearby enemies")
	await process_frame
	await clear_enemies()
	game.spawn_enemy("normal", 1)
	var walker: Enemy = get_nodes_in_group("enemies")[0]
	var start := walker.position
	walker._process(0.5)
	check(walker.position.distance_to(start) > 10, "Enemy follows the route")
	walker.distance = game.route.get_baked_length()
	walker._process(0.01)
	check(game.lives == 19, "Escaping enemy costs one life")
	await process_frame
	game.start_wave()
	game.start_wave()
	check(game.director.wave == 1, "Cannot start overlapping waves")
	for i in range(8):
		game.director._process(1.0)
	check(game.director.remaining == 0 and get_nodes_in_group("enemies").size() == 8, "First wave spawns eight enemies")
	await clear_enemies()
	game.director._process(0.01)
	check(not game.director.active, "Wave completes only after all enemies leave")
	game.start_wave()
	check(game.director.wave == 2 and game.director.remaining == 10, "Next wave increases enemy count")
	game.lives = 1
	game.on_escaped()
	check(game.game_over and paused and game.hud.end_panel.visible, "Zero lives pauses gameplay and shows restart")
	game.restart()
	await process_frame
	await process_frame
	check(not paused and current_scene.gold == 240 and current_scene.towers.is_empty(), "Restart reloads a clean playable session")
	print("SMOKE TEST FAILURES: ", failures)
	quit(0 if failures == 0 else 1)
