extends Node2D
## Composition and input routing. Menus use the same checked gameplay commands.
var launch_state: Dictionary = {}
var managed_flow: Node
var local_paused := false
var loss_reported := false
var sim: MayhemSimulation
var router: TwinStickInput
var camera: Camera2D
const WorldView = preload("res://prototype/presentation/world_view.gd")
var view: WorldView
var hud: CanvasLayer
var running := false
var build_kind := ""
var ghost := Vector2.ZERO
var message := ""
var message_time := 0.0
var checkpoint: Dictionary = {}
var selection: Dictionary = {}
var place_touch := -1
var debug_index := 0

func _ready() -> void:
	sim = MayhemSimulation.new(launch_state)
	sim.checkpoint_due.connect(save_checkpoint)
	router = TwinStickInput.new()
	add_child(router)
	view = WorldView.new()
	view.session = self
	add_child(view)
	camera = Camera2D.new()
	camera.position = sim.state.player.pos
	camera.zoom = Vector2.ONE * UserPreferences.camera_zoom
	add_child(camera)
	hud = preload("res://prototype/presentation/hud.gd").new()
	hud.session = self
	add_child(hud)
	ghost = sim.state.player.pos+Vector2(0,-100)
	checkpoint = sim.state.duplicate(true)
	if managed_flow!=null: running=true
	refresh_ui()

func _process(dt: float) -> void:
	message_time = maxf(0,message_time-dt)
	var movement := router.movement
	var aim := router.aim
	var input_allowed: bool = hud.open_panel=="" and not paused_now()
	if not OS.has_feature("mobile") and input_allowed:
		movement += Vector2(float(Input.is_physical_key_pressed(KEY_D))-float(Input.is_physical_key_pressed(KEY_A)),float(Input.is_physical_key_pressed(KEY_S))-float(Input.is_physical_key_pressed(KEY_W)))
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT): aim = (get_global_mouse_position()-sim.state.player.pos).normalized()
	if not input_allowed: movement=Vector2.ZERO; aim=Vector2.ZERO
	if running and not paused_now():
		sim.tick(minf(dt,0.05),movement.limit_length(),aim)
		camera.position = sim.state.player.pos
		if sim.state.lost:
			DirAccess.remove_absolute("user://suspend.bin")
			if managed_flow!=null and not loss_reported:
				loss_reported=true
				managed_flow.show_defeat()
		if input_allowed and Input.is_physical_key_pressed(KEY_E) and not sim.state.lost: action("interact")
	refresh_ui()

func paused_now() -> bool:
	return local_paused or (is_instance_valid(hud) and hud.open_panel in ["options","developer"])

func apply_preferences() -> void:
	camera.zoom=Vector2.ONE*UserPreferences.camera_zoom
	hud.root.theme=MenuTheme.create()
	hud.layout(hud.get_viewport().get_visible_rect().size)
	refresh_ui()

func notify(text: String) -> void:
	message = text
	message_time = 3.5

func refresh_ui() -> void:
	TutorialGuide.observe(sim.state)
	if is_instance_valid(hud):
		hud.refresh()
		if managed_flow!=null: hud.root.visible=not local_paused
	if is_instance_valid(view): view.refresh()

func context_target() -> Dictionary:
	if is_instance_valid(hud) and hud.open_panel in ["object","confirm"] and not hud.panel_target.is_empty():
		return hud.panel_target
	return InteractionGuide.target(sim.state,selection)

func _unhandled_input(event: InputEvent) -> void:
	if not running or local_paused: return
	if managed_flow!=null and event is InputEventKey and event.pressed and event.physical_keycode==KEY_ESCAPE:
		managed_flow.back()
		get_viewport().set_input_as_handled()
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.physical_keycode==KEY_ESCAPE:
			if hud.open_panel!="": hud.close_panel()
			elif build_kind!="": action("cancel_build")
			else: hud.show_panel("options")
		var keys={KEY_E:"interact",KEY_F:"load",KEY_G:"collect",KEY_T:"repair",KEY_X:"dismantle",KEY_Q:"slot",KEY_R:"reload",KEY_SPACE:"dodge",KEY_C:"skill",KEY_H:"heal"}
		if keys.has(event.physical_keycode): action(keys[event.physical_keycode])
	if event is InputEventMouseMotion and not OS.has_feature("mobile") and hud.is_world_point(event.position):
		ghost = get_global_mouse_position()
	if event is InputEventMouseButton and event.pressed and event.device>=0 and event.button_index==MOUSE_BUTTON_LEFT and hud.is_world_point(event.position):
		if build_kind!="": ghost=get_global_mouse_position()
		else: select_at(get_global_mouse_position())
	if event is InputEventScreenTouch:
		if event.pressed and hud.is_world_point(event.position):
			place_touch=event.index
			if build_kind!="": ghost=screen_to_world(event.position)
			else: select_at(screen_to_world(event.position))
		elif not event.pressed and event.index==place_touch:
			place_touch=-1
	if event is InputEventScreenDrag and event.index==place_touch and hud.is_world_point(event.position) and build_kind!="":
		ghost=screen_to_world(event.position)

func screen_to_world(p: Vector2) -> Vector2:
	return get_canvas_transform().affine_inverse()*p

func select_at(at: Vector2) -> void:
	for pair in [["building",sim.state.structures],["source",sim.state.sources],["core",[sim.state.core]],["loot",sim.state.loot]]:
		for data in pair[1]:
			if at.distance_to(data.pos)<38:
				selection={"type":pair[0],"data":data}
				notify(InteractionGuide.title(selection) + (" · Etkileşim için yaklaş." if sim.state.player.pos.distance_to(data.pos)>MayhemCatalog.REACH else " seçildi."))
				return
	selection={}

func place_at(at: Vector2) -> void:
	if build_kind=="" or sim.state.lost: return
	if sim.state.player.down: notify("Yaralıyken inşa edemezsin. Kliniğe sürün."); return
	var b := BuildingSystem.place(sim.state,build_kind,at)
	if b.is_empty(): notify("Kırmızı alan geçersiz: engelden ve canlılardan uzak, boş arazi seç.")
	else:
		selection={"type":"building","data":b}
		build_kind=""
		notify("Şantiye hazır. Yaklaş → Teslim et. Kaynak eksikse rehberi izle.")
	refresh_ui()

func save_checkpoint() -> void:
	checkpoint=sim.state.duplicate(true)
	if MayhemSave.write("user://checkpoint.bin",checkpoint): notify("Checkpoint kaydedildi · Bölüm %d" % sim.state.wave)

func action(command: String) -> void:
	if managed_flow!=null:
		if command=="save": managed_flow.save_and_home(); return
		if command=="menu": managed_flow.new_setup(); return
		if command=="new": managed_flow.new_setup(); return
		if command=="resume": managed_flow.resume_saved(); return
		if local_paused and command!="retry": return
	if command in ["new","menu","legacy","resume","retry"]:
		match command:
			"new":
				sim.state=MayhemState.fresh(hud.character.selected,hud.location.selected,hud.variation.selected)
				running=true
				place_touch=-1
				router.clear()
				build_kind=""
				selection={}
				hud.close_panel()
				checkpoint=sim.state.duplicate(true)
				MayhemSave.write("user://checkpoint.bin",checkpoint)
				DirAccess.remove_absolute("user://suspend.bin")
				notify("Sol analogla işaretli oduna yaklaş. Rehber adım adım yardımcı olacak.")
			"menu":
				running=false
				router.clear()
				hud.close_panel()
			"legacy": get_tree().change_scene_to_file("res://scenes/main.tscn")
			"resume":
				if sim.state.lost: notify("Yenilgiden sonra checkpoint seç."); return
				var restored := MayhemSave.read("user://suspend.bin")
				if restored.is_empty() or restored.lost: notify("Devam edilebilecek bir kayıt yok."); return
				sim.state=restored
				TutorialGuide.ensure(sim.state)
				var saved_checkpoint := MayhemSave.read("user://checkpoint.bin")
				if not saved_checkpoint.is_empty(): checkpoint=saved_checkpoint
				running=true
				router.clear()
				selection={}
				build_kind=""
				hud.close_panel()
				notify("Kaldığın yerden devam. Rehber ilerlemen korundu.")
			"retry":
				loss_reported=false
				if checkpoint.is_empty(): return
				sim.state=MayhemSave.retry(checkpoint,sim.state)
				TutorialGuide.ensure(sim.state)
				DirAccess.remove_absolute("user://suspend.bin")
				running=true
				selection={}
				build_kind=""
				hud.close_panel()
		refresh_ui()
		return
	if not running or sim.state.lost: return
	var s: Dictionary=sim.state
	var target := context_target()
	var b: Dictionary = target.data if not target.is_empty() and target.type=="building" else {}
	if not b.is_empty() and (not s.structures.has(b) or s.player.pos.distance_to(b.pos)>MayhemCatalog.REACH):
		notify("İşlem için tesise yaklaş."); return
	if s.player.down and command not in ["save","zoom_in","zoom_out","heal","context"]:
		if command=="interact" and not b.is_empty() and b.kind=="clinic": PlayerSystem.clinic(s,b)
		else: notify("Yaralısın. Kliniğe sürün; savaşamazsın.")
		return
	match command:
		"context":
			if build_kind!="": place_at(ghost)
			else: hud.primary()
		"build":
			if build_kind!="": action("cancel_build")
			else: hud.show_panel("build")
		"cancel_build": build_kind=""; notify("Yerleştirme iptal edildi.")
		"tutorial_skip": s.tutorial.skipped=true; notify("Rehber gizlendi. Menüden yeniden açabilirsin.")
		"tutorial_toggle":
			s.tutorial.skipped=not s.tutorial.skipped
			if not s.tutorial.skipped and s.tutorial.step>=TutorialGuide.STEPS.size(): s.tutorial.step=0
			notify("Rehber gösteriliyor." if not s.tutorial.skipped else "Rehber gizlendi.")
		"interact":
			if not b.is_empty():
				if not b.built:
					var moved := BuildingSystem.deliver(s,b)
					notify("%d malzeme teslim edildi." % moved if moved>0 else "Gerekli malzeme çantanda yok. Tesisi açıp eksikleri gör.")
				elif b.kind=="clinic": notify("Klinikte iyileştin." if PlayerSystem.clinic(s,b) else "Klinik çalışır durumda ve çantanda 1 odun olmalı.")
				else: hud.show_panel("object")
			elif not target.is_empty() and target.type in ["source","loot"]:
				if PlayerSystem.gather(s,target.data): notify("Malzeme çantana alındı.")
				elif PhysicalInventory.total(s.player.inventory)>=30: notify("Çanta dolu. Depoya bırak veya malzeme teslim et.")
				else: notify("Kaynak henüz hazır değil veya tükenmiş. Kısa bir süre bekle.")
			else: notify("Toplamak için işaretli kaynağa yaklaş.")
		"drop": PlayerSystem.drop(s); notify("Taşıdıkların yere bırakıldı.")
		"load":
			if not b.is_empty():
				var moved := ProductionSystem.load_input(s,b)
				notify("%d malzeme yüklendi." % moved if moved>0 else "Yüklenemedi: tarif malzemesi yok veya girdi kutusu dolu.")
		"collect":
			if not b.is_empty():
				var moved := ProductionSystem.collect(s,b)
				notify("%d ürün alındı." % moved if moved>0 else "Ürün hazır değil veya çanta dolu.")
		"repair":
			if target.get("type")=="core" and s.player.pos.distance_to(s.core.pos)<95 and s.core.repair_cd<=0 and s.core.hp<s.core.max_hp:
				if PhysicalInventory.remove(s.player.inventory,{"wood":1}):
					var amount := minf(30,s.core.max_hp-s.core.hp)
					s.core.hp+=amount; s.stats.player.repair+=int(amount); s.core.repair_cd=0.7
					notify("Merkez onarıldı.")
				else: notify("Onarım için 1 odun taşı.")
			elif not b.is_empty(): notify("Yapı onarıldı." if BuildingSystem.repair(s,b) else "Onarım için 1 odun gerekir; hasarlı yapıya yaklaş.")
			else: notify("Merkez sağlam veya tamire hazır değil.")
		"dismantle":
			if not b.is_empty():
				BuildingSystem.dismantle(s,b)
				hud.close_panel()
				selection={}
				notify("Söküldü. İade edilen malzemeleri yerden al.")
		"upgrade":
			if not b.is_empty(): notify("Yapı geliştirildi." if ProductionSystem.upgrade(s,b) else "Geliştirme: 2 metal + 2 odun gerekir; en çok seviye 3.")
		"modify":
			if not b.is_empty(): notify("Silah geliştirildi." if PlayerSystem.modify(s,b) else "Çalışan atölyede 1 parça gerekir; en çok seviye 3.")
		"connect":
			if not b.is_empty() and b.built:
				b.links=[]
				var connected := PowerGraph.connect_nearest(s,b) if b.kind=="cable" else LogisticsSystem.connect_nearest(s,b)
				notify("Uçlar bağlandı." if connected else "Uygun iki uç bulunamadı. Yapılar yakın ve aradaki arazi açık olmalı.")
		"toggle":
			if not b.is_empty(): b.enabled=not b.enabled; notify("Tesis açık." if b.enabled else "Tesis kapatıldı.")
		"slot": s.player.slot+=1; s.player.slot=-1 if s.player.slot>=s.player.weapons.size() else s.player.slot
		"reload": notify("Şarjör doldu." if PlayerSystem.reload_weapon(s) else "Menzilli silah seç; çantanda mermi olsun. Dolu şarjör doldurulmaz.")
		"equip": notify("Silah kuşanıldı." if PlayerSystem.equip(s) else "Önce tezgahta bir silah üretip çantana al.")
		"dodge":
			var movement := router.movement
			if movement.length()<0.1: movement=Vector2(float(Input.is_physical_key_pressed(KEY_D))-float(Input.is_physical_key_pressed(KEY_A)),float(Input.is_physical_key_pressed(KEY_S))-float(Input.is_physical_key_pressed(KEY_W)))
			CombatSystem.dodge(s,movement)
		"skill": CombatSystem.skill(s)
		"heal": notify("Medkit kullanıldı." if PlayerSystem.heal(s) else "Çantanda medkit yok veya yaralısın.")
		"wave":
			if MayhemWaves.begin(s): hud.close_panel(); notify("Saldırı yaklaşıyor. Üretim hattını ve merkezi koru!")
			else: notify("Saldırı zaten sürüyor.")
		"save":
			if MayhemSave.write("user://suspend.bin",s):
				running=false; router.clear(); hud.close_panel()
				notify("Kaydedildi. Kayıttan devam ile dönebilirsin.")
			else: notify("Kayıt yazılamadı.")
		"zoom_in": camera.zoom=(camera.zoom*1.15).clamp(Vector2.ONE*0.7,Vector2.ONE*2)
		"zoom_out": camera.zoom=(camera.zoom/1.15).clamp(Vector2.ONE*0.7,Vector2.ONE*2)
		"debug":
			s.unranked=true
			s.wave=[5,10,11,21,41,61,81,101,121][debug_index%9]; debug_index+=1
			s.phase="prepare"; s.phase_time=120; s.enemies.clear(); s.projectiles.clear()
			notify("UNRANKED · Bölüm %d" % s.wave)
	refresh_ui()

func _notification(what: int) -> void:
	if what==NOTIFICATION_APPLICATION_PAUSED and running and sim!=null and not sim.state.lost:
		MayhemSave.write("user://suspend.bin",sim.state)
