extends CanvasLayer
## Compact mobile shell. Only one scrollable panel can be open at a time.
var session: Node
var root: Control
var stats: Label
var resources: Label
var mission: Panel
var mission_title: Label
var mission_hint: Label
var mission_progress: Label
var toast: Label
var menu: PanelContainer
var report: PanelContainer
var report_text: Label
var character: OptionButton
var location: OptionButton
var variation: OptionButton
var minimap: Control
var panel: Panel
var panel_title: Label
var panel_info: Label
var panel_scroll: ScrollContainer
var panel_body: VBoxContainer
var panel_feedback: Label
var panel_close: Button
var panel_target: Dictionary = {}
var open_panel := ""
var controls: Dictionary = {}
var dock: Array[Button] = []
var menu_button: Button
var skip_button: Button
var developer_enabled := false
var size := Vector2(960,540)

static func style(color: Color, border: Color = Color("#819b88")) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.border_color = border
	box.set_border_width_all(2)
	box.set_corner_radius_all(12)
	box.set_content_margin_all(12)
	return box

func make_label(parent: Node, font_size: int = 18) -> Label:
	var label := Label.new()
	label.add_theme_font_size_override("font_size",font_size)
	label.add_theme_color_override("font_color",Color("#fff3d9"))
	label.clip_text = true
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label

func make_button(parent: Node, text: String, callback: Callable, id: String = "") -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0,ceilf(54*UserPreferences.ui_scale))
	button.pressed.connect(callback)
	button.focus_mode = Control.FOCUS_NONE
	parent.add_child(button)
	if id != "": controls[id] = button
	return button

func _ready() -> void:
	root = Control.new()
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	root.theme = MenuTheme.create()
	var bar := Panel.new()
	bar.name = "TopBar"
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.position = Vector2(8,8)
	bar.size = Vector2(944,50)
	root.add_child(bar)
	stats = make_label(root,18)
	resources = make_label(root,16)
	menu_button = make_button(root,"Menü",show_panel.bind("options"),"menu")
	mission = Panel.new()
	mission.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(mission)
	mission_title = make_label(mission,19)
	mission_hint = make_label(mission,16)
	mission_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mission_hint.clip_text = false
	mission_hint.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
	mission_progress = make_label(mission,15)
	skip_button = make_button(mission,"Atla",session.action.bind("tutorial_skip"),"tutorial_skip")
	toast = make_label(root,17)
	toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	toast.clip_text = false
	toast.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
	toast.add_theme_stylebox_override("normal",style(Color("#25473e")))
	toast.add_theme_color_override("font_color",Color("#ffec9d"))
	for pair in [["İnşa","build"],["Çanta","inventory"],["Yaklaş","context"],["Kaç","dodge"],["Yetenek","skill"]]:
		var callback: Callable = session.action.bind(pair[1])
		if pair[1]=="inventory": callback = show_panel.bind(pair[1])
		dock.append(make_button(root,pair[0],callback,pair[1]))
	make_button(root,"Doldur",session.action.bind("reload"),"reload")
	var pads := preload("res://prototype/presentation/pad_view.gd").new()
	pads.router = session.router
	pads.session = session
	root.add_child(pads)
	minimap = preload("res://prototype/presentation/minimap.gd").new()
	minimap.session = session
	minimap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(minimap)
	panel = Panel.new()
	root.add_child(panel)
	panel_feedback = make_label(panel,16)
	panel_feedback.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel_feedback.add_theme_color_override("font_color",Color("#ffe29c"))
	panel_title = make_label(panel,21)
	panel_info = make_label(panel,16)
	panel_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel_close = make_button(panel,"Kapat",close_panel,"close")
	panel_scroll = ScrollContainer.new()
	panel_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	panel.add_child(panel_scroll)
	panel_body = VBoxContainer.new()
	panel_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel_body.add_theme_constant_override("separation",8)
	panel_scroll.add_child(panel_body)
	create_menu()
	create_report()
	panel.hide()
	layout(get_viewport().get_visible_rect().size)

func create_menu() -> void:
	menu = PanelContainer.new()
	root.add_child(menu)
	var choices := VBoxContainer.new()
	choices.add_theme_constant_override("separation",8)
	menu.add_child(choices)
	var title := make_label(choices,25)
	title.text = "MAYHEM · Çayırı savun"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	character = OptionButton.new()
	for profile in MayhemCatalog.CHARACTERS: character.add_item(profile.name)
	location = OptionButton.new()
	location.add_item("Merkez: Batı çayırı")
	location.add_item("Merkez: Doğu çayırı")
	variation = OptionButton.new()
	variation.add_item("Orman: A")
	variation.add_item("Orman: B")
	for choice in [character,location,variation]:
		choice.custom_minimum_size.y = 48
		choices.add_child(choice)
	make_button(choices,"Oyuna başla",session.action.bind("new"),"start")
	make_button(choices,"Kayıttan devam",session.action.bind("resume"),"resume_menu")

	var hint := make_label(choices,15)
	hint.text = "Oyun içindeki rehber sana ilk üretim hattını gösterecek."
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func create_report() -> void:
	report = PanelContainer.new()
	root.add_child(report)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation",8)
	report.add_child(content)
	report_text = make_label(content,18)
	report_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	make_button(content,"Checkpoint'ten yeniden dene",session.action.bind("retry"))
	make_button(content,"Yeni oturum",session.action.bind("menu"))

func layout(viewport_size: Vector2) -> void:
	size = viewport_size
	root.size = size
	root.theme=MenuTheme.create()
	for button in dock:
		button.add_theme_font_size_override("font_size",roundi(18*UserPreferences.ui_scale))

	root.get_node("TopBar").size = Vector2(size.x-16,50)
	stats.position = Vector2(20,10)
	stats.size = Vector2(size.x-240,24)
	resources.position = Vector2(20,34)
	resources.size = Vector2(size.x-140,20)
	menu_button.position = Vector2(size.x-112,9)
	menu_button.size = Vector2(96,48)
	menu_button.custom_minimum_size.y = 48
	mission.position = Vector2(16,70)
	mission.size = Vector2(minf(500*UserPreferences.ui_scale,size.x-200),110*UserPreferences.ui_scale)
	mission_title.position = Vector2(12,6)
	mission_title.size = Vector2(mission.size.x-94,27)
	mission_hint.position = Vector2(12,36*UserPreferences.ui_scale)
	mission_hint.size = Vector2(mission.size.x-94,44*UserPreferences.ui_scale)
	mission_progress.position = Vector2(12,82*UserPreferences.ui_scale)
	mission_progress.size = Vector2(mission.size.x-24,22)
	skip_button.position = Vector2(mission.size.x-78,5)
	skip_button.size = Vector2(70,48)
	skip_button.custom_minimum_size.y = 48
	var center_width := minf(568*UserPreferences.ui_scale,size.x-360)
	var x := (size.x-center_width)/2
	var widths := [0.17,0.17,0.32,0.16,0.18]
	for i in range(dock.size()):
		var width: float = (center_width-32)*widths[i]
		dock[i].position = Vector2(x,size.y-70)
		dock[i].size = Vector2(width,ceilf(54*UserPreferences.ui_scale))
		x += width+8
	session.router.centers = [Vector2(88,size.y-90),Vector2(size.x-88,size.y-90)]
	controls.reload.position = Vector2(size.x-136,size.y-224)
	controls.reload.size = Vector2(96,54)
	toast.position = Vector2(175,size.y-126)
	toast.size = Vector2(size.x-350,50)
	minimap.position = Vector2(size.x-156,76)
	panel.position = Vector2((size.x-560)/2,78)
	panel.size = Vector2(560,size.y-250)
	panel_title.position = Vector2(14,10)
	panel_title.size = Vector2(415,36)
	panel_close.position = Vector2(446,8)
	panel_close.custom_minimum_size.y = ceilf(50*UserPreferences.ui_scale)
	panel_close.size = Vector2(102,ceilf(50*UserPreferences.ui_scale))
	panel_info.position = Vector2(14,panel_close.position.y+panel_close.size.y+10)
	panel_info.size = Vector2(532,50)
	panel_scroll.position = Vector2(14,panel_info.position.y+panel_info.size.y+8)
	panel_scroll.size = Vector2(532,panel.size.y-panel_scroll.position.y-14)
	panel_feedback.position = Vector2(14,panel.size.y-54)
	panel_feedback.size = Vector2(532,46)
	menu.size = Vector2(540,452)
	menu.position = (size-menu.size)/2
	report.size = Vector2(540,330)
	report.position = (size-report.size)/2

func close_panel() -> void:
	open_panel = ""
	panel.hide()
	panel_target = {}
	session.router.clear()
	session.refresh_ui()

func show_panel(kind: String) -> void:
	if kind=="options" and session.managed_flow!=null:
		session.managed_flow.pause_game()
		return
	open_panel = kind
	panel.show()
	session.router.clear()
	panel_target = session.context_target() if kind=="object" else {}
	for child in panel_body.get_children():
		panel_body.remove_child(child)
		child.queue_free()
	panel_scroll.scroll_vertical = 0
	var s: Dictionary = session.sim.state
	session.message_time = 0
	match kind:
		"build":
			panel_title.text = "İnşa · önce yerleştir, sonra teslim et"
			panel_info.text = "Kaynaklar çantanda olsa bile şantiyeye fiziksel teslim gerekir."
			var order: Array = MayhemCatalog.BUILDINGS.keys()
			var recommended: String = TutorialGuide.recommended_build(s)
			if recommended!="":
				order.erase(recommended)
				order.push_front(recommended)
			for building_kind in order:
				var data: Dictionary = MayhemCatalog.BUILDINGS[building_kind]
				var text: String = "%s   ·   %s" % [data.name,MayhemCatalog.resource_text(data.cost)]
				if building_kind==recommended: text="Önerilen · "+text
				if s.wave < data.wave: text = "%s   ·   Bölüm %d'de açılır" % [data.name,data.wave]
				var button := make_button(panel_body,text,choose_building.bind(building_kind))
				button.add_theme_font_size_override("font_size",17)
				button.disabled = s.wave < data.wave
		"inventory":
			panel_title.text = "Çanta ve ekipman"
			var pairs = [["Silah slotunu değiştir","slot"],["Üretilen silahı kuşan","equip"],["Şarjörü doldur (mermi gerekir)","reload"],["Medkit kullan","heal"],["Taşıdıklarını yere bırak","drop"]]
			for pair in pairs: make_button(panel_body,pair[0],session.action.bind(pair[1]))
		"object":
			panel_title.text = InteractionGuide.title(panel_target)
			if panel_target.is_empty(): return
			if panel_target.type=="core":
				make_button(panel_body,"Merkezi onar · 1 odun / en çok 30 HP",session.action.bind("repair"))
			elif panel_target.type=="building":
				var b: Dictionary = panel_target.data
				if not b.built: make_button(panel_body,"Malzemeleri teslim et",session.action.bind("interact"))
				else:
					if b.kind=="clinic": make_button(panel_body,"Klinikte iyileş · 1 odun",session.action.bind("interact"))
					if b.kind=="turret": make_button(panel_body,"Mühimmat yükle",session.action.bind("load"))
					elif b.kind=="depot":
						make_button(panel_body,"Çantadan depoya koy",session.action.bind("load"))
						make_button(panel_body,"Depodan çantaya al",session.action.bind("collect"))
					elif MayhemCatalog.RECIPES.has(b.kind):
						make_button(panel_body,"Girdi yükle · "+MayhemCatalog.resource_text(MayhemCatalog.RECIPES[b.kind].input),session.action.bind("load"))
						make_button(panel_body,"Ürünleri al",session.action.bind("collect"))
					if b.kind in ["conveyor","cable"]: make_button(panel_body,"Yakındaki iki ucu bağla",session.action.bind("connect"))
					if b.kind=="workshop": make_button(panel_body,"Silahı modifiye et · 1 parça",session.action.bind("modify"))
					if MayhemCatalog.RECIPES.has(b.kind) or b.kind=="turret":
						make_button(panel_body,"Geliştir · 2 metal + 2 odun",session.action.bind("upgrade"))
					make_button(panel_body,"Çalışmayı aç / kapat",session.action.bind("toggle"))
				make_button(panel_body,"Tamir et · 1 odun",session.action.bind("repair"))
				make_button(panel_body,"Sök · malzemenin bir kısmı geri döner",confirm_dismantle)
		"confirm":
			panel_title.text = "Bu yapıyı sökmek istiyor musun?"
			panel_info.text = "İnşa malzemesinin yarısı yere dökülür. Bu işlemi geri alamazsın."
			make_button(panel_body,"Evet, sök",session.action.bind("dismantle"))
		"options":
			panel_title.text = "Oyun menüsü"
			panel_info.text = "Oyun duraklatıldı. İşin bitince paneli kapat."
			for pair in [["Saldırıyı başlat","wave"],["Kaydet ve ara ver","save"],["Kayıttan devam","resume"],["Kamerayı yakınlaştır","zoom_in"],["Kamerayı uzaklaştır","zoom_out"],
				["Rehberi göster / gizle","tutorial_toggle"]]:
				make_button(panel_body,pair[0],session.action.bind(pair[1]))
			make_button(panel_body,"Geliştirici araçlarını aç",show_panel.bind("developer"))
		"developer":
			panel_title.text = "Geliştirici paneli · UNRANKED"
			panel_info.text = "Bölüm atlamak bu oturumu derecesiz yapar. Malzemeler ücretsiz verilmez."
			developer_enabled = true
			make_button(panel_body,"Test bölümüne atla",session.action.bind("debug"))
	session.refresh_ui()

func confirm_dismantle() -> void:
	var target := panel_target
	show_panel("confirm")
	panel_target = target

func choose_building(kind: String) -> void:
	session.build_kind = kind
	session.ghost = session.sim.state.player.pos + Vector2(110,-20)
	close_panel()
	session.notify("Yeşil bir alan seç → Yerleştir. Sonra malzemeleri taşı.")

func primary() -> void:
	var target: Dictionary = session.context_target()
	if target.is_empty():
		session.notify("İşaretli nesneye sol analogla yaklaş.")
	elif target.type in ["building","core"]:
		if target.type=="building" and not target.data.built: session.action("interact")
		else: show_panel("object")
	else: session.action("interact")

func is_world_point(point: Vector2) -> bool:
	if not session.running or session.sim.state.lost or open_panel!="": return false
	if point.y < 64: return false
	if mission.visible and mission.get_rect().has_point(point): return false
	if Rect2(minimap.position,Vector2(140,94)).has_point(point): return false
	for button in dock:
		if button.visible and button.get_rect().has_point(point): return false
	for center in session.router.centers:
		if point.distance_to(center)<78: return false
	return true

func refresh() -> void:
	if root==null: return
	var s: Dictionary = session.sim.state
	var p: Dictionary = s.player
	var current_size := get_viewport().get_visible_rect().size
	if current_size != size: layout(current_size)
	mission_title.add_theme_font_size_override("font_size",roundi(19*UserPreferences.ui_scale))
	mission_hint.add_theme_font_size_override("font_size",roundi(16*UserPreferences.ui_scale))
	var preparing: String = "Hazırlık %d sn" % ceili(s.phase_time) if s.phase=="prepare" else ("SALDIRI %d sn" % ceili(s.phase_time) if s.phase=="warning" else "Savaş")
	stats.text = "HP %d/%d    Merkez %d/%d    Bölüm %d · %s%s" % [p.hp,MayhemCatalog.CHARACTERS[p.character].hp,s.core.hp,s.core.max_hp,s.wave,preparing," · UNRANKED" if s.unranked else ""]
	resources.text = "Odun %d   Taş %d   Cevher %d   Metal %d   Mermi %d     Çanta %d/30" % [p.inventory.get("wood",0),p.inventory.get("stone",0),p.inventory.get("ore",0),p.inventory.get("metal",0),p.inventory.get("ammo",0),PhysicalInventory.total(p.inventory)]
	var task := TutorialGuide.task(s)
	mission_title.text = task.title
	mission_hint.text = task.hint
	mission_progress.text = task.progress
	mission.visible = session.running and not s.lost and not s.tutorial.skipped and open_panel=="" and s.tutorial.step<TutorialGuide.STEPS.size()
	minimap.visible = session.running and not s.lost and open_panel==""
	menu.visible = not session.running
	report.visible = s.lost and session.running and session.managed_flow==null
	panel.visible = session.running and not s.lost and open_panel!=""
	menu_button.visible = session.running and not s.lost
	session.router.enabled = session.running and not s.lost and open_panel=="" and not session.local_paused
	for button in dock: button.visible = session.running and not s.lost and open_panel==""
	controls.reload.visible = session.running and not s.lost and open_panel=="" and p.slot>=0 and p.weapons[p.slot]!=""
	controls.context.text = InteractionGuide.primary(session.context_target())
	if session.build_kind!="":
		controls.context.text = "Yerleştir"
		controls.build.text = "İptal"
	else: controls.build.text = "İnşa"
	controls.dodge.text = "Kaç %.0f" % p.dodge_cd if p.dodge_cd>0 else "Kaç"
	controls.skill.text = "Yetenek %.0f" % p.skill_cd if p.skill_cd>0 else "Yetenek"
	panel_feedback.hide()
	toast.text = session.message if session.message_time>0 else ("Yaralısın! Kliniğe sürün." if p.down else "")
	toast.visible = session.running and not s.lost and session.message_time>0
	if open_panel=="inventory":
		var slot: String = "Yakın dövüş" if p.slot<0 else "%s (%d)" % [p.weapons[p.slot] if p.weapons[p.slot]!="" else "Boş slot",p.magazines[p.slot]]
		panel_info.text = "%s\nSeçili: %s · %s" % [MayhemCatalog.resource_text(p.inventory),slot,"Ağır yük" if p.heavy else "Hafif yük"]
	elif open_panel=="object":
		if not InteractionGuide.exists(s,panel_target): close_panel(); return
		var b: Dictionary = panel_target.data
		if panel_target.type=="core": panel_info.text = "Yalnız savunma hedefi · HP %d/%d" % [b.hp,b.max_hp]
		elif panel_target.type=="building":
			if not b.built:
				panel_info.text = "Gerekli: %s\nTeslim: %s" % [MayhemCatalog.resource_text(MayhemCatalog.BUILDINGS[b.kind].cost),MayhemCatalog.resource_text(b.delivered)]
			else:
				panel_info.text = "%s · HP %d/%d · Seviye %d\nGirdi: %s | Ürün: %s" % [InteractionGuide.status(b),b.hp,b.max_hp,b.level,MayhemCatalog.resource_text(b.input),MayhemCatalog.resource_text(b.stock if b.kind=="depot" else b.output)]
	if s.lost:
		report_text.text = "Merkez düştü veya kan kaybı bitti.\nSüre %.0f sn · Rekor %d · Deneme %d\nSen: %.0f hasar / %d kill\nKule/takım: %.0f hasar / %d kill\nToplama %d · Tamir %d · Üretim %d" % [s.stats.seconds,s.stats.peak_wave,s.stats.attempt,s.stats.player.damage,s.stats.player.kills,s.stats.team.damage,s.stats.team.kills,s.stats.player.gathered,s.stats.player.repair,s.stats.team.production]
	minimap.queue_redraw()
