class_name MenuTheme
extends RefCounted
const FOREST=Color("#183d30")
const CREAM=Color("#fff0c7")
const GOLD=Color("#d9b76e")
static func box(color: Color, border: Color=GOLD) -> StyleBoxFlat:
	var style:=StyleBoxFlat.new()
	style.bg_color=color
	style.border_color=border
	style.set_border_width_all(2)
	style.set_corner_radius_all(13)
	style.set_content_margin_all(12)
	style.shadow_color=Color(0.04,0.1,0.07,0.45)
	style.shadow_size=4
	style.shadow_offset=Vector2(0,4)
	return style
static func create() -> Theme:
	var theme:=Theme.new()
	theme.default_font_size=roundi(18*UserPreferences.ui_scale)
	for state in ["normal","hover","pressed","focus","disabled"]:
		var color:=Color("#e8d7a8")
		var border:=Color("#866b41")
		if state=="hover" or state=="focus": color=Color("#fff0c7"); border=Color("#f5cc6e")
		if state=="pressed": color=Color("#cfba85")
		if state=="disabled": color=Color("#81917a"); border=Color("#5f7564")
		theme.set_stylebox(state,"Button",box(color,border))
		theme.set_stylebox(state,"OptionButton",box(color,border))
		theme.set_color("font_color","Button",FOREST)
		theme.set_color("font_focus_color","Button",FOREST)
		theme.set_color("font_hover_color","Button",FOREST)
		theme.set_color("font_pressed_color","Button",FOREST)
		theme.set_color("font_disabled_color","Button",Color("#344c3f"))
	theme.set_color("font_color","Label",CREAM)
	theme.set_color("font_color","OptionButton",FOREST)
	theme.set_stylebox("panel","PanelContainer",box(Color("#1c3b30")))
	theme.set_stylebox("panel","Panel",box(Color("#1c3b30")))
	return theme
static func label(parent: Node,text: String,font_size: int=18) -> Label:
	var label:=Label.new()
	label.text=text
	label.add_theme_font_size_override("font_size",roundi(font_size*UserPreferences.ui_scale))
	label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	label.mouse_filter=Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label
static func button(parent: Node,text: String,callback: Callable,primary: bool=false) -> Button:
	var button:=Button.new()
	button.text=text
	button.set_meta("primary",primary)
	button.custom_minimum_size.y=touch_height(parent)
	button.pressed.connect(callback)
	button.focus_mode=Control.FOCUS_ALL
	if primary:
		for state in ["normal","hover","pressed","focus"]:
			button.add_theme_stylebox_override(state,box(Color("#749b35") if state=="focus" else (Color("#537d25") if state!="pressed" else Color("#4c7526")),CREAM if state=="focus" else GOLD))
		for state in ["font_color","font_hover_color","font_pressed_color","font_focus_color"]: button.add_theme_color_override(state,CREAM)
	parent.add_child(button)
	return button

static func required_height(dpi: float,stretch: float) -> float:
	return ceilf(maxf(54*UserPreferences.ui_scale,48*dpi/(160*maxf(stretch,0.1))))
static func touch_height(parent: Node) -> float:
	if not OS.has_feature("android"): return ceilf(54*UserPreferences.ui_scale)
	var logical: Vector2=parent.get_viewport().get_visible_rect().size
	var physical: Vector2=Vector2(DisplayServer.window_get_size())
	return required_height(maxf(160,DisplayServer.screen_get_dpi()),physical.y/maxf(1,logical.y))
static func safe_bounds(viewport: Viewport) -> Rect2:
	var logical:=viewport.get_visible_rect().size
	if not OS.has_feature("android"): return Rect2(Vector2.ZERO,logical)
	var window_size:=Vector2(DisplayServer.window_get_size())
	var origin:=Vector2(DisplayServer.window_get_position())
	var physical:=Rect2(DisplayServer.get_display_safe_area()).intersection(Rect2(origin,window_size))
	if not physical.has_area(): return Rect2(Vector2.ZERO,logical)
	var factor:=window_size/logical
	return Rect2((physical.position-origin)/factor,physical.size/factor)
