class_name GameHUD
extends CanvasLayer
signal build_requested(kind: String)
signal upgrade_requested
signal wave_requested
signal restart_requested
signal close_requested
var stats: Label
var wave_button: Button
var hint: Label
var build_buttons: Dictionary = {}
var upgrade_button: Button
var close_button: Button
var end_panel: PanelContainer
var end_label: Label

static func box(color: Color, border: Color = Color("#d7dfb5")) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = border
	style.set_border_width_all(2)
	style.set_corner_radius_all(12)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	return style

func _ready() -> void:
	layer = 2
	process_mode = Node.PROCESS_MODE_ALWAYS
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	var theme := Theme.new()
	theme.default_font_size = 18
	theme.set_stylebox("normal", "Button", box(Color("#355445")))
	theme.set_stylebox("hover", "Button", box(Color("#4c7256"), Color("#fff1ae")))
	theme.set_stylebox("pressed", "Button", box(Color("#254536"), Color("#ffe78c")))
	theme.set_stylebox("disabled", "Button", box(Color("#53605a"), Color("#7f8a78")))
	theme.set_color("font_color", "Button", Color("#fff4d6"))
	theme.set_color("font_disabled_color", "Button", Color("#a8b2a4"))
	root.theme = theme
	var top := PanelContainer.new()
	top.position = Vector2(10, 8)
	top.size = Vector2(940, 54)
	top.add_theme_stylebox_override("panel", box(Color("#233f37")))
	root.add_child(top)
	var bar := HBoxContainer.new()
	top.add_child(bar)
	stats = Label.new()
	stats.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_child(stats)
	wave_button = Button.new()
	wave_button.custom_minimum_size = Vector2(205, 44)
	wave_button.pressed.connect(func(): wave_requested.emit())
	bar.add_child(wave_button)
	var bottom := PanelContainer.new()
	bottom.position = Vector2(10, 439)
	bottom.size = Vector2(940, 93)
	bottom.add_theme_stylebox_override("panel", box(Color("#233f37")))
	root.add_child(bottom)
	var layout := VBoxContainer.new()
	bottom.add_child(layout)
	hint = Label.new()
	hint.add_theme_font_size_override("font_size", 16)
	layout.add_child(hint)
	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 10)
	layout.add_child(actions)
	for kind in ["archer", "mage", "cannon"]:
		var button := Button.new()
		button.custom_minimum_size = Vector2(218, 48)
		button.pressed.connect(func(): build_requested.emit(kind))
		actions.add_child(button)
		build_buttons[kind] = button
	upgrade_button = Button.new()
	upgrade_button.custom_minimum_size = Vector2(360, 48)
	upgrade_button.pressed.connect(func(): upgrade_requested.emit())
	actions.add_child(upgrade_button)
	close_button = Button.new()
	close_button.text = "Kapat"
	close_button.custom_minimum_size = Vector2(110, 48)
	close_button.pressed.connect(func(): close_requested.emit())
	actions.add_child(close_button)
	end_panel = PanelContainer.new()
	end_panel.position = Vector2(265, 150)
	end_panel.size = Vector2(430, 230)
	end_panel.add_theme_stylebox_override("panel", box(Color("#293f42"), Color("#ffd48d")))
	root.add_child(end_panel)
	var end_content := VBoxContainer.new()
	end_content.alignment = BoxContainer.ALIGNMENT_CENTER
	end_content.add_theme_constant_override("separation", 20)
	end_panel.add_child(end_content)
	end_label = Label.new()
	end_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_label.add_theme_font_size_override("font_size", 25)
	end_content.add_child(end_label)
	var retry := Button.new()
	retry.text = "Yeniden başlat"
	retry.custom_minimum_size.y = 56
	retry.pressed.connect(func(): restart_requested.emit())
	end_content.add_child(retry)
	end_panel.hide()

func refresh(game: Node) -> void:
	stats.text = "  MAYHEM    •    Altın: %d     Can: %d     Dalga: %d" % [game.gold, game.lives, game.director.wave]
	wave_button.text = "Dalga sürüyor…" if game.director.active else "Dalgayı başlat  ▶"
	wave_button.disabled = game.director.active or game.game_over
	var selected: bool = game.selected_site >= 0
	var occupied: bool = game.towers.has(game.selected_site)
	hint.text = "Çayır Muhafızları • Bir + noktasına dokun ve kule kur. Hazır olunca dalgayı başlat."
	if selected:
		hint.text = "Okçu: hızlı tek hedef  •  Büyücü: güçlü tek hedef  •  Topçu: alan hasarı"
	for kind in build_buttons:
		var button: Button = build_buttons[kind]
		button.visible = not occupied
		button.text = "%s  •  %d altın" % [GameData.TOWERS[kind].title, GameData.TOWERS[kind].cost]
		button.disabled = not selected or game.gold < GameData.TOWERS[kind].cost or game.game_over
	upgrade_button.visible = occupied
	close_button.visible = selected
	if occupied:
		var tower: Tower = game.towers[game.selected_site]
		var cost := GameData.upgrade_cost(tower.kind, tower.level)
		hint.text = "%s • Seviye %d/3 • Hasar %d • Menzil %d" % [GameData.TOWERS[tower.kind].title, tower.level, tower.stat("damage"), tower.stat("range")]
		upgrade_button.text = "En yüksek seviye" if tower.level == 3 else "Seviye %d  •  %d altın" % [tower.level + 1, cost]
		upgrade_button.disabled = tower.level >= 3 or game.gold < cost or game.game_over
	end_panel.visible = game.game_over
	end_label.text = "Çayır düştü!\n%d dalgaya ulaştın." % game.director.wave
