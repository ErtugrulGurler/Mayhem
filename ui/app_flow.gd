extends Node
## Owns screen lifecycle; no gameplay scene exists until start/continue succeeds.
var draft: Dictionary={"character":0,"location":0,"variation":0}
var game: Node
var page: Control
var page_name:="home"
var history: Array[String]=[]
var notice:=""
var suspend_path:="user://suspend.bin"
var layer: CanvasLayer
var surface: Control
var backdrop: Control
var launching:=false
func _ready() -> void:
	UserPreferences.load_settings()
	layer=CanvasLayer.new()
	layer.layer=10
	add_child(layer)
	surface=Control.new()
	surface.mouse_filter=Control.MOUSE_FILTER_IGNORE
	surface.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(surface)
	backdrop=preload("res://ui/art/menu_backdrop.gd").new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	surface.add_child(backdrop)
	get_tree().root.go_back_requested.connect(back)
	show_page("home")
func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode==KEY_ESCAPE:
		back()
		get_viewport().set_input_as_handled()
func show_page(kind: String) -> void:
	page_name=kind
	if is_instance_valid(page):
		surface.remove_child(page); page.queue_free()
	page=load("res://ui/screens/"+kind+".tscn").instantiate()
	page.flow=self
	surface.add_child(page)
	backdrop.visible=not is_instance_valid(game)
	if is_instance_valid(game): game.local_paused=true; game.router.clear(); game.refresh_ui()
func navigate(kind: String) -> void:
	history.append(page_name)
	notice=""
	show_page(kind)
func back() -> void:
	if is_instance_valid(page) and dismiss_popup(page): return
	if page_name=="game":
		if game.hud.open_panel!="": game.hud.close_panel()
		elif game.build_kind!="": game.action("cancel_build")
		else: pause_game()
	elif page_name=="pause": resume_game()
	elif page_name=="defeat": home_after_defeat()
	elif not history.is_empty():
		notice=""
		show_page(history.pop_back())
	elif page_name!="home": show_page("home")
func new_setup() -> void:
	draft={"character":0,"location":0,"variation":0}
	navigate("character")
func request_start() -> void:
	if FileAccess.file_exists(suspend_path): navigate("confirm")
	else: commit_new()
func commit_new() -> void:
	if launching: return
	launching=true
	var initial:=MayhemState.fresh(draft.character,draft.location,draft.variation)
	var candidate:=make_game(initial)
	if not MayhemSave.write("user://checkpoint.bin",candidate.sim.state):
		candidate.queue_free(); launching=false; notice="Yeni oturum kaydı yazılamadı. Eski ara verme kaydı korundu."; show_page("summary"); return
	if is_instance_valid(game): remove_child(game); game.queue_free()
	game=candidate
	DirAccess.remove_absolute(suspend_path)
	game.checkpoint=game.sim.state.duplicate(true)
	enter_game()
	launching=false
func make_game(initial: Dictionary) -> Node:
	var candidate=preload("res://prototype/scenes/session.tscn").instantiate()
	candidate.launch_state=initial
	candidate.managed_flow=self
	candidate.local_paused=true
	add_child(candidate)
	return candidate
func enter_game() -> void:
	if is_instance_valid(page): surface.remove_child(page); page.queue_free()
	page=null
	page_name="game"
	history.clear()
	backdrop.hide()
	game.local_paused=false
	game.camera.make_current()
	game.running=true
	game.router.clear()
	game.refresh_ui()
func resume_saved() -> void:
	var stored:=MenuData.suspend(suspend_path)
	if stored.is_empty():
		notice="Ara verme kaydı geçersiz veya okunamıyor. Checkpoint bir devam kaydı değildir."
		show_page("home"); return
	if is_instance_valid(game): remove_child(game); game.queue_free()
	game=make_game(stored)
	var saved_checkpoint:=MayhemSave.read("user://checkpoint.bin")
	if not saved_checkpoint.is_empty(): game.checkpoint=saved_checkpoint
	enter_game()
func pause_game() -> void:
	if not is_instance_valid(game): return
	game.local_paused=true
	game.router.clear()
	history.clear()
	notice=""
	show_page("pause")
func resume_game() -> void:
	if is_instance_valid(game): enter_game()
func save_and_home() -> void:
	if not is_instance_valid(game) or game.sim.state.lost: return
	if not MayhemSave.write(suspend_path,game.sim.state):
		notice="Kayıt yazılamadı. Oyun korunuyor; yeniden dene."
		show_page("pause"); return
	MenuData.remember(game.sim.state,"Kaydedilen oturum")
	unload_game()
	history.clear()
	notice="Oturum kaydedildi."
	show_page("home")
func unload_game() -> void:
	if is_instance_valid(game):
		remove_child(game); game.queue_free()
	game=null
func show_defeat() -> void:
	if page_name=="defeat": return
	game.local_paused=true
	MenuData.remember(game.sim.state,"Son yenilgi")
	DirAccess.remove_absolute(suspend_path)
	history.clear()
	show_page("defeat")
func retry_checkpoint() -> void:
	if not is_instance_valid(game): return
	game.action("retry")
	enter_game()
func home_after_defeat() -> void:
	unload_game(); history.clear(); notice=""; show_page("home")
func show_tutorial() -> void:
	game.sim.state.tutorial.skipped=false
	if game.sim.state.tutorial.step>=TutorialGuide.STEPS.size(): game.sim.state.tutorial.step=0
	enter_game()
func developer() -> void:
	enter_game()
	game.hud.show_panel("developer")
func apply_preferences() -> void:
	backdrop.queue_redraw()
	if is_instance_valid(game): game.apply_preferences()

func dismiss_popup(node: Node) -> bool:
	if node is OptionButton and node.get_popup().visible:
		node.get_popup().hide()
		return true
	for child in node.get_children():
		if dismiss_popup(child): return true
	return false
