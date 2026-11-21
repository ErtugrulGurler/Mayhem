extends SceneTree
var checks:=0
var failures:=0
var app: Node
func check(ok: bool,text: String) -> void:
	checks+=1
	if ok: print("PASS ",text)
	else: failures+=1; push_error(text)
func bytes_at(path: String) -> PackedByteArray:
	return FileAccess.get_file_as_bytes(path) if FileAccess.file_exists(path) else PackedByteArray()
func _initialize() -> void: call_deferred("run")
func run() -> void:
	for path in ["user://suspend.bin","user://checkpoint.bin","user://preferences.cfg","user://last_statistics.json"]:
		DirAccess.remove_absolute(path)
	app=load("res://ui/main_menu.tscn").instantiate()
	root.add_child(app); current_scene=app
	await process_frame
	check(app.page_name=="home" and app.game==null,"MM-001 startup has separate menu and zero gameplay instances")
	var clock: float=app.backdrop.clock
	await create_timer(0.06).timeout
	check(app.backdrop.clock>clock,"MM-002 menu decoration animates independently of gameplay")
	UserPreferences.low_effects=true
	clock=app.backdrop.clock
	await create_timer(0.06).timeout
	check(app.backdrop.clock==clock,"MM-011 low effects actually stop decorative motion")
	UserPreferences.low_effects=false
	check(app.page.buttons["continue"].disabled,"MM-007 missing suspend disables Continue")
	check(app.page.buttons.friends.disabled,"MM-009 no fake multiplayer")
	check(MenuData.statistics().is_empty(),"MM-010 no fabricated statistics")
	var invalid_stats:=FileAccess.open("user://last_statistics.json",FileAccess.WRITE)
	invalid_stats.store_string(JSON.stringify({"version":1,"stats":SessionStatistics.fresh()})); invalid_stats.close()
	check(MenuData.statistics().is_empty(),"MM-010 malformed statistics handled safely")
	DirAccess.remove_absolute("user://last_statistics.json")
	app.navigate("statistics")
	check(app.page.body.get_child(0).text=="Henüz kayıtlı istatistik yok","MM-010 empty statistics message")
	app.back()
	var checkpoint:=MayhemState.fresh()
	MayhemSave.write("user://checkpoint.bin",checkpoint)
	app.show_page("home")
	check(app.page.buttons["continue"].disabled,"MM-007 checkpoint is never treated as suspend")
	var invalid:=FileAccess.open("user://suspend.bin",FileAccess.WRITE)
	invalid.store_string("invalid save")
	invalid.close()
	app.show_page("home")
	check(app.page.buttons["continue"].disabled,"MM-007 corrupted save disables Continue safely")
	app.resume_saved()
	check(app.game==null and not app.notice.is_empty(),"MM-007 failed continue reports understandable error")
	DirAccess.remove_absolute("user://suspend.bin")
	var malformed:=MayhemState.fresh()
	malformed.player.hp="invalid number"
	MayhemSave.write("user://suspend.bin",malformed)
	check(MenuData.suspend().is_empty(),"MM-007 checksum-valid malformed player is rejected")
	DirAccess.remove_absolute("user://suspend.bin")
	check(MenuTheme.required_height(420,2)>=63 and MenuTheme.required_height(320,2)>=48,"MM-017 explicit physical-pixel / stretch / dpi target conversion")
	var original_checkpoint:=bytes_at("user://checkpoint.bin")
	app.new_setup()
	app.page.select_character(3)
	app.navigate("map")
	app.draft.location=1; app.draft.variation=1
	app.navigate("summary"); app.back(); app.back()
	check(app.page_name=="character" and app.draft.character==3 and app.draft.location==1 and app.draft.variation==1,"MM-004 back preserves all selections")
	check(bytes_at("user://checkpoint.bin")==original_checkpoint and app.game==null,"MM-004 setup does not mutate world or save")
	app.navigate("map"); app.navigate("summary"); app.request_start()
	var game: Node=app.game
	game.set_process(false)
	check(app.page_name=="game" and app.page==null,"MM-004 start hands input to gameplay")
	check(game.sim.state.player.character==3 and game.sim.state.location==1 and game.sim.state.variation==1,"MM-005 selected character and location reach real session")
	check(game.sim.state.player.inventory.is_empty() and game.sim.state.structures.is_empty(),"MM-006 new session has no free equipment or buildings")
	var s: Dictionary=game.sim.state
	var building:=MayhemCatalog.building("smelter",s.core.pos+Vector2(100,0),1)
	building.built=true; building.input={"ore":2,"wood":1}
	s.structures.append(building)
	EnemySystem.spawn(s,"normal",s.core.pos+Vector2(300,0))
	s.player.skill_cd=5
	app.pause_game()
	var snapshot:=var_to_bytes(s)
	for i in range(10): game._process(0.1)
	game.action("skill")
	check(var_to_bytes(s)==snapshot,"MM-013 pause freezes world, AI, production, waves and cooldowns")
	check(not game.router.enabled and not game.hud.root.visible,"MM-013 pause hides gameplay input targets")
	app.navigate("controls"); app.back()
	check(app.page_name=="pause","MM-016 nested panel Back returns to pause")
	app.suspend_path="user://missing_parent/cannot_write.bin"
	app.save_and_home()
	check(app.game==game and app.page_name=="pause" and app.notice.contains("yazılamadı"),"MM-014 failed write stays in paused world")
	app.suspend_path="user://suspend.bin"
	app.save_and_home()
	check(app.game==null and app.page_name=="home" and not app.page.buttons["continue"].disabled,"MM-014 successful save returns to real menu")
	var disk:=MenuData.suspend()
	check(var_to_bytes(disk)==snapshot,"MM-014 full saved state exactly matches paused state")
	app.resume_saved()
	game=app.game; game.set_process(false)
	check(var_to_bytes(game.sim.state)==snapshot,"MM-007 resume restores world, player, buffers, RNG and tutorial exactly")
	app.pause_game(); app.save_and_home()
	var saved_bytes:=bytes_at("user://suspend.bin")
	app.new_setup(); app.navigate("map"); app.navigate("summary"); app.request_start()
	check(app.page_name=="confirm" and app.game==null,"MM-008 existing save requires overwrite confirmation")
	app.back()
	check(app.page_name=="summary" and bytes_at("user://suspend.bin")==saved_bytes,"MM-008 cancel preserves exact old save")
	app.request_start(); app.commit_new()
	game=app.game; game.set_process(false)
	check(game.sim.state.structures.is_empty() and game.sim.state.player.inventory.is_empty() and not FileAccess.file_exists("user://suspend.bin"),"MM-008 confirmed new session resets and removes suspend")
	check(game.sim.state.wave==1 and game.sim.state.stats.seconds==0,"MM-006 no previous progression inherited")
	app.pause_game(); app.navigate("settings")
	app.page.scale_choice.select(2); app.page.effects_choice.select(1); app.page.zoom.value=1.6
	app.page.apply_settings()
	UserPreferences.load_settings()
	check(is_equal_approx(UserPreferences.ui_scale,1.1) and UserPreferences.low_effects and is_equal_approx(UserPreferences.camera_zoom,1.6),"MM-011 persisted working UI/effect/zoom settings")
	check(is_equal_approx(game.camera.zoom.x,1.6),"MM-011 settings actually affect game camera")
	app.back()
	app.resume_game()
	game.sim.state.lost=true
	game._process(0)
	check(app.page_name=="defeat" and not FileAccess.file_exists("user://suspend.bin"),"MM-015 defeat invalidates suspend and opens separate screen")
	var old_seed: int=game.sim.state.attack_seed
	app.retry_checkpoint()
	game=app.game; game.set_process(false)
	check(app.page_name=="game" and not game.sim.state.lost and game.sim.state.attack_seed!=old_seed,"MM-015 checkpoint retry differs from exact suspend continuation")
	app.pause_game()
	root.go_back_requested.emit()
	check(app.page_name=="game" and not game.local_paused,"MM-016 Android Back signal resumes pause")
	app.pause_game(); app.save_and_home()
	check(not MenuData.statistics().is_empty() and MenuData.statistics().stats.team.damage==0,"MM-010 real statistics retain separate team damage")
	# Check all four catalog choices reach the session without inventing profiles.
	for i in range(4):
		DirAccess.remove_absolute("user://suspend.bin")
		app.new_setup(); app.page.select_character(i); app.navigate("map"); app.navigate("summary"); app.request_start()
		app.game.set_process(false)
		check(app.game.sim.state.player.character==i and app.game.sim.state.player.hp==MayhemCatalog.CHARACTERS[i].hp,"MM-005 real profile "+str(i))
		app.pause_game(); app.save_and_home()
	UserPreferences.ui_scale=1; UserPreferences.low_effects=false; UserPreferences.camera_zoom=1.2
	UserPreferences.save_settings()
	app.queue_free(); await process_frame
	print("MENU NAVIGATION: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
