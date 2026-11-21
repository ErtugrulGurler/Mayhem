extends SceneTree
var checks:=0
var failures:=0
var app: Node
func check(ok: bool,text: String) -> void:
	checks+=1
	if ok: print("PASS ",text)
	else: failures+=1; push_error(text)
func click(button: Control,touch: bool=false,freeze_game: bool=false) -> void:
	for i in range(3): await process_frame
	var at:=button.get_global_rect().get_center()
	for down in [true,false]:
		var event: InputEvent
		if touch:
			var t:=InputEventScreenTouch.new()
			t.position=at; t.index=0; t.pressed=down
			event=t
		else:
			var t:=InputEventMouseButton.new()
			t.position=at; t.global_position=at; t.button_index=MOUSE_BUTTON_LEFT; t.pressed=down
			event=t
		root.push_input(event,true)
		if freeze_game and is_instance_valid(app.game): app.game.set_process(false)
		await process_frame
	await process_frame
func key(code: Key) -> void:
	for down in [true,false]:
		var event:=InputEventKey.new()
		event.keycode=code; event.physical_keycode=code; event.pressed=down
		root.push_input(event,true)
		await process_frame
func _initialize() -> void: call_deferred("run")
func run() -> void:
	DirAccess.remove_absolute("user://suspend.bin")
	app=load("res://ui/main_menu.tscn").instantiate()
	root.add_child(app); current_scene=app
	for i in range(4): await process_frame
	check(root.gui_get_focus_owner()==app.page.buttons.new,"MM-016 primary menu button has keyboard focus")
	await key(KEY_ENTER)
	check(app.page_name=="character","MM-016 Enter opens real new-game setup")
	await key(KEY_ESCAPE)
	check(app.page_name=="home","MM-016 Escape navigates back without quitting")
	await click(app.page.buttons.new,true)
	check(app.page_name=="character","MM-004 native GUI touchscreen opens setup")
	await click(app.page.cards[2],true)
	check(app.draft.character==2,"MM-005 native character card selects Cem")
	await click(app.page.buttons.next)
	check(app.page_name=="map","MM-004 pointer continues to map")
	await click(app.page.buttons.next)
	check(app.page_name=="summary","MM-004 pointer continues to summary")
	await click(app.page.buttons.start)
	check(app.page_name=="game" and app.game.sim.state.player.character==2,"MM-005 native start creates correct gameplay")
	await click(app.game.hud.menu_button,true)
	check(app.page_name=="pause" and app.game.local_paused,"MM-013 mobile HUD pause button opens themed pause")
	var before:=var_to_bytes(app.game.sim.state)
	await key(KEY_C)
	for i in range(6): await process_frame
	check(var_to_bytes(app.game.sim.state)==before,"MM-013 actual paused frames and skill key cannot change state")
	await click(app.page.buttons.save,true)
	check(app.page_name=="home" and not app.page.buttons["continue"].disabled,"MM-014 native Save and Menu enables Continue")
	await click(app.page.buttons["continue"],true,true)
	check(app.page_name=="game" and var_to_bytes(app.game.sim.state)==before,"MM-007 native Continue restores exact paused snapshot")
	app.pause_game()
	app.navigate("settings")
	app.page.scale_choice.get_popup().popup()
	await process_frame
	root.go_back_requested.emit()
	check(app.page_name=="settings" and not app.page.scale_choice.get_popup().visible,"MM-016 Android Back closes dropdown before leaving settings")
	app.back()
	check(app.page_name=="pause","MM-016 next Back returns to pause")
	app.save_and_home()
	root.go_back_requested.emit()
	check(app.page_name=="home" and app.game==null,"MM-016 Android Back on home does not quit or launch gameplay")
	app.queue_free(); await process_frame
	print("MENU POINTER: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
