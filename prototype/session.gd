extends Node2D
## Composition root only. Simulation and visuals stay in separate modules.
var sim: MayhemSimulation
var router: TwinStickInput
var camera: Camera2D
var view: Node2D
var hud: CanvasLayer
var running:=false
var build_kind: String=""
var ghost:=Vector2.ZERO
var message: String="Yakındaki odun, taş ve cevheri E / Topla ile al."
var checkpoint: Dictionary={}
var touch_press:=Vector2.ZERO
var place_touch:=-1
var debug_index:=0

func _ready() -> void:
	sim=MayhemSimulation.new()
	sim.checkpoint_due.connect(save_checkpoint)
	router=TwinStickInput.new()
	add_child(router)
	view=preload("res://prototype/presentation/world_view.gd").new()
	view.session=self
	add_child(view)
	camera=Camera2D.new()
	camera.position=sim.state.player.pos
	camera.zoom=Vector2.ONE*1.2
	add_child(camera)
	hud=preload("res://prototype/presentation/hud.gd").new()
	hud.session=self
	add_child(hud)
	ghost=sim.state.player.pos+Vector2(90,0)
	checkpoint=sim.state.duplicate(true)

func _process(dt: float) -> void:
	var movement:=router.movement
	if not OS.has_feature("mobile"):
		movement+=Vector2(float(Input.is_physical_key_pressed(KEY_D))-float(Input.is_physical_key_pressed(KEY_A)),float(Input.is_physical_key_pressed(KEY_S))-float(Input.is_physical_key_pressed(KEY_W)))
	var aim:=router.aim
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and not OS.has_feature("mobile"): aim=(get_global_mouse_position()-sim.state.player.pos).normalized()
	if running:
		sim.tick(minf(dt,0.05),movement.limit_length(),aim)
		camera.position=sim.state.player.pos
		if sim.state.lost: DirAccess.remove_absolute("user://suspend.bin")
		if Input.is_physical_key_pressed(KEY_E) and not sim.state.lost: message=sim.interact()
	view.queue_redraw()
	hud.refresh()

func _unhandled_input(event: InputEvent) -> void:
	if not running: return
	if event is InputEventKey and event.pressed and not event.echo:
		var keys={KEY_E:"interact",KEY_F:"load",KEY_G:"collect",KEY_T:"repair",KEY_X:"dismantle",KEY_Q:"slot",KEY_R:"reload",KEY_SPACE:"dodge",KEY_C:"skill",KEY_H:"heal"}
		if keys.has(event.physical_keycode): action(keys[event.physical_keycode])
	if event is InputEventMouseMotion and not OS.has_feature("mobile"):
		ghost=get_global_mouse_position()
	if event is InputEventMouseButton and event.pressed and event.device>=0 and event.button_index==MOUSE_BUTTON_LEFT and build_kind!="" and event.position.y>125 and event.position.y<325:
		place_at(get_global_mouse_position())
	if event is InputEventScreenTouch:
		if event.pressed and event.position.y>130 and event.position.y<325 and event.position.x<800 and build_kind!="":
			place_touch=event.index
			touch_press=event.position
			ghost=screen_to_world(event.position)
		elif not event.pressed and event.index==place_touch:
			place_at(ghost)
			place_touch=-1
	if event is InputEventScreenDrag and event.index==place_touch: ghost=screen_to_world(event.position)

func screen_to_world(p: Vector2) -> Vector2:
	return get_canvas_transform().affine_inverse()*p

func place_at(at: Vector2) -> void:
	if build_kind=="" or sim.state.lost: return
	var b:=BuildingSystem.place(sim.state,build_kind,at)
	message="Şantiye kuruldu; yaklaş ve Topla / E ile malzeme teslim et." if not b.is_empty() else "Yerleşim reddedildi: işgal, arazi veya teknoloji."

func save_checkpoint() -> void:
	checkpoint=sim.state.duplicate(true)
	MayhemSave.write("user://checkpoint.bin",checkpoint)
	message="CHECKPOINT • Bölüm %d başlangıcı kaydedildi." % sim.state.wave

func action(command: String) -> void:
	if command in ["new","menu","legacy","resume","retry"]:
		match command:
			"new":
				sim.state=MayhemState.fresh(hud.character.selected,hud.location.selected,hud.variation.selected)
				running=true
				place_touch=-1
				router.clear()
				build_kind=""
				hud.selector.select(0)
				checkpoint=sim.state.duplicate(true)
				MayhemSave.write("user://checkpoint.bin",checkpoint)
				DirAccess.remove_absolute("user://suspend.bin")
			"menu":
				running=false
				router.clear()
			"legacy": get_tree().change_scene_to_file("res://scenes/main.tscn")
			"resume":
				if sim.state.lost:
					message="Yenilgiden sonra ara verme kaydı kullanılamaz; checkpoint seç."
					return
				var restored:=MayhemSave.read("user://suspend.bin")
				if not restored.is_empty() and not restored.lost:
					sim.state=restored
					var saved_checkpoint:=MayhemSave.read("user://checkpoint.bin")
					if not saved_checkpoint.is_empty(): checkpoint=saved_checkpoint
					running=true
					router.clear()
					message="Aynı dünya ve RNG ile devam."
				else: message="Geçerli ara verme kaydı yok."
			"retry":
				if checkpoint.is_empty(): return
				sim.state=MayhemSave.retry(checkpoint,sim.state)
				DirAccess.remove_absolute("user://suspend.bin")
				running=true
		return
	if not running or sim.state.lost: return
	var s: Dictionary=sim.state
	var b:=sim.nearest()
	if s.player.down and command not in ["save","zoom_in","zoom_out","heal"]:
		if command=="interact" and not b.is_empty() and b.kind=="clinic": PlayerSystem.clinic(s,b)
		return
	match command:
		"interact": message=sim.interact()
		"drop": PlayerSystem.drop(s)
		"load":
			if not b.is_empty(): message="Yüklendi: %d" % ProductionSystem.load_input(s,b)
		"collect":
			if not b.is_empty(): message="Alındı: %d" % ProductionSystem.collect(s,b)
		"repair":
			if s.player.pos.distance_to(s.core.pos)<95 and s.core.repair_cd<=0 and s.core.hp<s.core.max_hp:
				if PhysicalInventory.remove(s.player.inventory,{"wood":1}):
					var amount:=minf(30,s.core.max_hp-s.core.hp)
					s.core.hp+=amount
					s.stats.player.repair+=int(amount)
					s.core.repair_cd=0.7
			elif not b.is_empty(): BuildingSystem.repair(s,b)
		"dismantle":
			if not b.is_empty(): BuildingSystem.dismantle(s,b)
		"upgrade":
			if not b.is_empty(): message="Geliştirme: %s" % ProductionSystem.upgrade(s,b)
		"modify":
			if not b.is_empty(): message="Modifiye: %s" % PlayerSystem.modify(s,b)
		"connect":
			if not b.is_empty() and b.built:
				b.links=[]
				if b.kind=="cable": message="Kablo: %s" % PowerGraph.connect_nearest(s,b)
				elif b.kind=="conveyor": message="Konveyör: %s" % LogisticsSystem.connect_nearest(s,b)
		"toggle":
			if not b.is_empty(): b.enabled=not b.enabled
		"slot": s.player.slot+=1; s.player.slot=-1 if s.player.slot>=s.player.weapons.size() else s.player.slot
		"reload": message="Doldurma: %s" % PlayerSystem.reload_weapon(s)
		"equip": message="Kuşanma: %s" % PlayerSystem.equip(s)
		"dodge":
			var movement:=router.movement
			if movement.length()<0.1: movement=Vector2(float(Input.is_physical_key_pressed(KEY_D))-float(Input.is_physical_key_pressed(KEY_A)),float(Input.is_physical_key_pressed(KEY_S))-float(Input.is_physical_key_pressed(KEY_W)))
			CombatSystem.dodge(s,movement)
		"skill": CombatSystem.skill(s)
		"heal": PlayerSystem.heal(s)
		"wave": MayhemWaves.begin(s)
		"save":
			if MayhemSave.write("user://suspend.bin",s):
				message="Kaydedildi. Sürdür ile aynı noktaya dön."
				running=false
				router.clear()
		"zoom_in": camera.zoom=(camera.zoom*1.15).clamp(Vector2.ONE*0.7,Vector2.ONE*2)
		"zoom_out": camera.zoom=(camera.zoom/1.15).clamp(Vector2.ONE*0.7,Vector2.ONE*2)
		"debug":
			s.unranked=true
			s.wave=[5,10,11,21,41,61,81,101,121][debug_index%9]
			debug_index+=1
			s.phase="prepare"
			s.phase_time=120
			s.enemies.clear()
			s.projectiles.clear()
			message="UNRANKED • Bölüm %d • Malzemeler normal toplanır." % s.wave
func _notification(what: int) -> void:
	if what==NOTIFICATION_APPLICATION_PAUSED and running and sim!=null and not sim.state.lost:
		MayhemSave.write("user://suspend.bin",sim.state)
