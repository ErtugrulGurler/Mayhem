class_name UserPreferences
extends RefCounted
static var ui_scale := 1.0
static var low_effects := false
static var camera_zoom := 1.2
static func load_settings() -> void:
	ui_scale=1.0; low_effects=false; camera_zoom=1.2
	var config:=ConfigFile.new()
	if config.load("user://preferences.cfg")!=OK or config.get_value("meta","version",0)!=1: return
	var scale_value=config.get_value("ui","scale",1.0)
	var zoom_value=config.get_value("ui","zoom",1.2)
	var effects_value=config.get_value("ui","low_effects",false)
	if scale_value is float or scale_value is int: ui_scale=clampf(float(scale_value),0.9,1.1)
	if zoom_value is float or zoom_value is int: camera_zoom=clampf(float(zoom_value),0.7,2.0)
	if effects_value is bool: low_effects=effects_value
static func save_settings() -> bool:
	var config:=ConfigFile.new()
	config.set_value("meta","version",1)
	config.set_value("ui","scale",ui_scale)
	config.set_value("ui","low_effects",low_effects)
	config.set_value("ui","zoom",camera_zoom)
	if config.save("user://preferences.cfg.tmp")!=OK: return false
	return DirAccess.rename_absolute("user://preferences.cfg.tmp","user://preferences.cfg")==OK
