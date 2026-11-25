extends CanvasLayer
## Viewport anchors plus safe-area padding keep the play area clear.

@onready var root: Control = $Root
@onready var move_stick: Control = $Root/MoveStick
@onready var aim_stick: Control = $Root/AimStick
var header: PanelContainer
var title: Label
var hint: Label
var move_label: Label
var aim_label: Label

func _ready() -> void:
	header = PanelContainer.new()
	header.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color("233f36")
	style.border_color = Color("9ba979")
	style.set_border_width_all(2)
	style.set_corner_radius_all(16)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	header.add_theme_stylebox_override("panel", style)
	root.add_child(header)
	var lines := VBoxContainer.new()
	header.add_child(lines)
	title = make_label("MAYHEM   /   KEŞİF ALANI", 19, Color("fff0c5"))
	lines.add_child(title)
	lines.add_child(make_label("FAZ 0  ·  Hareket ve kamera prototipi", 14, Color("c4d3ae")))
	hint = make_label("Çayırda dolaş; kayalara ve ağaçlara yaklaş.", 16, Color("fff0c5"))
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(hint)
	move_label = make_label("HAREKET", 13, Color("fff0c5"))
	aim_label = make_label("YÖNEL", 13, Color("fff0c5"))
	for label in [move_label, aim_label]:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		root.add_child(label)
	var note := make_label("WASD / Oklar  ·  Sağ fare: yönel\nSağ analog yalnız yön verir; bu fazda saldırı yok.", 14, Color("f4edce"))
	note.name = "ControlsNote"
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(note)
	get_viewport().size_changed.connect(relayout)
	relayout()

func make_label(text: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0.05, 0.12, 0.09, 0.85))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 2)
	return label

func relayout() -> void:
	var view := get_viewport().get_visible_rect().size
	# DisplayServer safe area is in physical screen pixels; convert to canvas units.
	var margin := Vector2(24, 24)
	if OS.has_feature("android"):
		var safe := DisplayServer.get_display_safe_area()
		var screen := Vector2(DisplayServer.screen_get_size())
		if safe.has_area() and screen.x > 0 and screen.y > 0:
			var scale_factor := view / screen
			margin.x = maxf(margin.x, maxf(safe.position.x, screen.x - safe.end.x) * scale_factor.x + 12)
			margin.y = maxf(margin.y, maxf(safe.position.y, screen.y - safe.end.y) * scale_factor.y + 12)
	var stick_size := clampf(view.y * 0.29, 136, 172)
	for stick in [move_stick, aim_stick]: stick.size = Vector2.ONE * stick_size
	var caption_height := maxf(move_label.get_combined_minimum_size().y, aim_label.get_combined_minimum_size().y)
	move_stick.position = Vector2(margin.x, view.y - margin.y - stick_size - caption_height - 4)
	aim_stick.position = Vector2(view.x - margin.x - stick_size, move_stick.position.y)
	header.position = margin
	header.size = Vector2(350, 72)
	hint.position = Vector2(view.x * 0.5 - 210, margin.y + maxf(72, header.get_combined_minimum_size().y) + 12)
	hint.size = Vector2(420, 26)
	move_label.position = move_stick.position + Vector2(0, stick_size + 4)
	move_label.size = Vector2(stick_size, 24)
	aim_label.position = aim_stick.position + Vector2(0, stick_size + 4)
	aim_label.size = Vector2(stick_size, 24)
	var note := root.get_node("ControlsNote") as Label
	var note_height := maxf(44, note.get_combined_minimum_size().y)
	note.position = Vector2(view.x * 0.5 - 220, view.y - margin.y - note_height)
	note.size = Vector2(440, note_height)
	for stick in [move_stick, aim_stick]: stick.queue_redraw()
