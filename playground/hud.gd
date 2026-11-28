extends CanvasLayer
var stats := Label.new()
var slots: Array[Button] = []
func _ready() -> void:
	var hud := $Root as Control
	hud.theme = MenuTheme.create()
	var bar := HBoxContainer.new()
	hud.add_child(bar)
	bar.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	bar.grow_horizontal = Control.GROW_DIRECTION_BOTH
	bar.offset_top = -65
	bar.offset_bottom = -11
	var group := ButtonGroup.new()
	for title in ["Boş El","Tabanca","Tüfek","Balta"]:
		var button := Button.new()
		button.text = title
		button.toggle_mode = true
		button.button_group = group
		button.custom_minimum_size = Vector2(96,54)
		bar.add_child(button)
		button.pressed.connect(get_parent().equip.bind(slots.size()))
		slots.append(button)
	slots[0].button_pressed = true
	var panel := PanelContainer.new()
	hud.add_child(panel)
	panel.position = Vector2(15,12)
	panel.add_child(stats)
	var menu := Button.new()
	hud.add_child(menu)
	menu.text = "Ana Menü"
	menu.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	menu.offset_left = -138
	menu.offset_right = -14
	menu.offset_top = 12
	menu.offset_bottom = 64
	menu.pressed.connect(get_parent().leave)
	var dodge := Button.new()
	hud.add_child(dodge)
	dodge.text = "Kaç"
	dodge.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	dodge.offset_left = -135
	dodge.offset_right = -25
	dodge.offset_top = -228
	dodge.offset_bottom = -174
	dodge.pressed.connect(get_parent().dodge)
	for item in [["MoveStick",Control.PRESET_BOTTOM_LEFT],["AimStick",Control.PRESET_BOTTOM_RIGHT]]:
		var stick: Control = hud.get_node(item[0])
		stick.set_anchors_and_offsets_preset(item[1])
		stick.offset_top = -168
		stick.offset_bottom = -8
		stick.offset_left = 8 if item[0]=="MoveStick" else -168
		stick.offset_right = 168 if item[0]=="MoveStick" else -8
