extends Node2D
## Composition root: owns the session, connects simulation signals to UI/effects.
var gold := 240
var lives := 20
var game_over := false
var selected_site := -1
var towers: Dictionary = {}
var site_buttons: Array[Button] = []
var route := Curve2D.new()
var director: WaveDirector
var hud: GameHUD

func _ready() -> void:
	for point in GameData.PATH:
		route.add_point(point)
	# Smooth corners, retaining an authored, deterministic route.
	for i in range(1, route.point_count - 1):
		var tangent := (route.get_point_position(i + 1) - route.get_point_position(i - 1)).normalized() * 28
		route.set_point_in(i, -tangent)
		route.set_point_out(i, tangent)
	var map := preload("res://scripts/visuals/map_view.gd").new()
	map.route = route
	add_child(map)
	director = WaveDirector.new()
	add_child(director)
	director.spawn_requested.connect(spawn_enemy)
	director.changed.connect(refresh)
	var sites_layer := CanvasLayer.new()
	sites_layer.layer = 1
	add_child(sites_layer)
	for i in range(GameData.SITES.size()):
		var button := Button.new()
		button.position = GameData.SITES[i] - Vector2(27, 27)
		button.size = Vector2(54, 54)
		button.text = "+"
		button.add_theme_font_size_override("font_size", 28)
		button.add_theme_stylebox_override("normal", GameHUD.box(Color(0.25, 0.38, 0.23, 0.65), Color("#d4e7a5")))
		button.pressed.connect(select_site.bind(i))
		sites_layer.add_child(button)
		site_buttons.append(button)
	hud = GameHUD.new()
	add_child(hud)
	hud.build_requested.connect(build_tower)
	hud.upgrade_requested.connect(upgrade_tower)
	hud.wave_requested.connect(start_wave)
	hud.restart_requested.connect(restart)
	hud.close_requested.connect(select_site.bind(-1))
	refresh()

func select_site(index: int) -> void:
	selected_site = index
	for id in towers:
		towers[id].selected = id == index
	refresh()

func build_tower(kind: String) -> void:
	if game_over or selected_site < 0 or towers.has(selected_site) or not GameData.TOWERS.has(kind):
		return
	var cost: int = GameData.TOWERS[kind].cost
	if gold < cost:
		return
	gold -= cost
	var tower := Tower.new()
	tower.kind = kind
	tower.position = GameData.SITES[selected_site]
	tower.selected = true
	tower.fired.connect(fire)
	towers[selected_site] = tower
	add_child(tower)
	site_buttons[selected_site].text = ""
	site_buttons[selected_site].modulate.a = 0.12
	refresh()

func upgrade_tower() -> void:
	if game_over or not towers.has(selected_site):
		return
	var tower: Tower = towers[selected_site]
	var cost := GameData.upgrade_cost(tower.kind, tower.level)
	if tower.level >= 3 or gold < cost:
		return
	gold -= cost
	tower.level += 1
	effect(tower.position, Color("#fff0a0"), 40)
	refresh()

func fire(tower: Tower, target: Enemy) -> void:
	var shot := Projectile.new()
	shot.position = tower.position - Vector2(0, 20)
	shot.target = target
	shot.last_position = target.position
	shot.damage = tower.stat("damage")
	shot.speed = tower.stat("speed")
	shot.splash = tower.stat("splash")
	shot.color = GameData.TOWERS[tower.kind].color
	shot.kind = tower.kind
	shot.impact.connect(effect)
	add_child(shot)

func spawn_enemy(kind: String, wave: int) -> void:
	var enemy := Enemy.new()
	enemy.configure(kind, wave, route)
	enemy.defeated.connect(on_defeated)
	enemy.escaped.connect(on_escaped)
	add_child(enemy)

func on_defeated(reward: int, at: Vector2) -> void:
	gold += reward
	effect(at, Color("#ffe186"), 22)
	refresh()

func on_escaped() -> void:
	lives = maxi(0, lives - 1)
	if lives == 0:
		game_over = true
		get_tree().paused = true
	refresh()

func effect(at: Vector2, color: Color, radius: float) -> void:
	var burst := preload("res://scripts/visuals/hit_effect.gd").new()
	burst.position = at
	burst.color = color
	burst.radius = radius
	add_child(burst)

func start_wave() -> void:
	if not game_over:
		director.start_wave()

func refresh() -> void:
	if is_instance_valid(hud):
		hud.refresh(self)

func restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
