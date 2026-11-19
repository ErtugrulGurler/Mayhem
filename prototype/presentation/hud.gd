extends CanvasLayer
var session: Node
var stats: Label
var context: Label
var inventory: Label
var status: Label
var selector: OptionButton
var menu: PanelContainer
var report: PanelContainer
var report_text: Label
var character: OptionButton
var location: OptionButton
var variation: OptionButton
var minimap: Control
var buttons: Dictionary={}
func button(parent: Control,text: String,at: Vector2,width: float,action: Callable) -> Button:
	var b:=Button.new()
	b.text=text
	b.position=at
	b.size=Vector2(width,46)
	b.pressed.connect(action)
	parent.add_child(b)
	return b
func label(parent: Control,at: Vector2,width: float) -> Label:
	var l:=Label.new()
	l.position=at
	l.size=Vector2(width,28)
	l.clip_text=true
	l.add_theme_color_override("font_color",Color("#fff2d0"))
	l.add_theme_color_override("font_shadow_color",Color("#263f39"))
	l.add_theme_constant_override("shadow_offset_x",1)
	l.add_theme_constant_override("shadow_offset_y",2)
	parent.add_child(l)
	return l
func _ready() -> void:
	var root:=Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter=Control.MOUSE_FILTER_IGNORE
	add_child(root)
	var theme:=Theme.new()
	theme.default_font_size=15
	for state in ["normal","hover","pressed","disabled"]:
		var style:=StyleBoxFlat.new()
		style.bg_color=Color("#36584f") if state!="pressed" else Color("#69825e")
		style.border_color=Color("#b0c2a4")
		style.set_border_width_all(1)
		style.set_corner_radius_all(8)
		theme.set_stylebox(state,"Button",style)
	root.theme=theme
	stats=label(root,Vector2(12,5),940)
	selector=OptionButton.new()
	selector.position=Vector2(12,38)
	selector.size=Vector2(230,46)
	selector.add_item("İnşa seç / kapat")
	for kind in MayhemCatalog.BUILDINGS:
		selector.add_item(MayhemCatalog.BUILDINGS[kind].name)
	selector.item_selected.connect(func(index):
		session.build_kind="" if index==0 else MayhemCatalog.BUILDINGS.keys()[index-1]
		session.message="Dünyada üst-orta alana dokun; yeşil önizleme geçerli. Malzeme sonra teslim edilir."
	)
	root.add_child(selector)
	var actions=[["Dalga", "wave"],["Kaydet","save"],["Sürdür","resume"],["Zoom +","zoom_in"],["Zoom -","zoom_out"],["DEBUG","debug"]]
	for i in range(actions.size()):
		button(root,actions[i][0],Vector2(252+i*116,38),108,session.action.bind(actions[i][1]))
	context=label(root,Vector2(12,90),780)
	context.add_theme_font_size_override("font_size",14)
	status=label(root,Vector2(180,292),600)
	status.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	minimap=preload("res://prototype/presentation/minimap.gd").new()
	minimap.session=session
	minimap.position=Vector2(805,100)
	minimap.mouse_filter=Control.MOUSE_FILTER_IGNORE
	root.add_child(minimap)
	var row=[["Topla / E","interact"],["Yükle / F","load"],["Ürün / G","collect"],["Tamir / T","repair"],["Sök / X","dismantle"]]
	for i in range(row.size()): button(root,row[i][0],Vector2(180+i*120,337),112,session.action.bind(row[i][1]))
	var combat=[["Silah / Q","slot"],["Doldur / R","reload"],["Kaç / Space","dodge"],["Yetenek / C","skill"],["İyileş / H","heal"]]
	for i in range(combat.size()): buttons[combat[i][1]]=button(root,combat[i][0],Vector2(180+i*120,391),112,session.action.bind(combat[i][1]))
	var extra=[["Kuşan","equip"],["Geliştir","upgrade"],["Modifiye","modify"],["Bağla","connect"],["Aç/Kapat","toggle"],["Bırak","drop"]]
	for i in range(extra.size()): button(root,extra[i][0],Vector2(180+i*100,445),94,session.action.bind(extra[i][1]))
	inventory=label(root,Vector2(12,502),940)
	var pad_view:=Node2D.new()
	pad_view.set_script(preload("res://prototype/presentation/pad_view.gd"))
	pad_view.router=session.router
	root.add_child(pad_view)
	menu=PanelContainer.new()
	menu.position=Vector2(225,135)
	menu.size=Vector2(510,340)
	root.add_child(menu)
	var choices:=VBoxContainer.new()
	choices.add_theme_constant_override("separation",8)
	menu.add_child(choices)
	var title:=Label.new()
	title.text="MAYHEM • Yerel P0\nTopla → taşı → inşa → üret → savun"
	title.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	choices.add_child(title)
	character=OptionButton.new()
	for c in MayhemCatalog.CHARACTERS: character.add_item(c.name)
	choices.add_child(character)
	location=OptionButton.new()
	location.add_item("Merkez: Batı çayırı")
	location.add_item("Merkez: Doğu çayırı")
	choices.add_child(location)
	variation=OptionButton.new()
	variation.add_item("Varyasyon A")
	variation.add_item("Varyasyon B")
	choices.add_child(variation)
	for pair in [["Sıfırdan başla","new"],["Ara verme kaydını sürdür","resume"],["Eski kule savunması demosu","legacy"]]:
		var b:=Button.new()
		b.text=pair[0]
		b.custom_minimum_size.y=44
		b.pressed.connect(session.action.bind(pair[1]))
		choices.add_child(b)
	report=PanelContainer.new()
	report.position=Vector2(190,130)
	report.size=Vector2(580,335)
	root.add_child(report)
	var end:=VBoxContainer.new()
	report.add_child(end)
	report_text=Label.new()
	report_text.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	end.add_child(report_text)
	for pair in [["Checkpoint'ten yeniden dene","retry"],["Yeni oturum","menu"]]:
		var b:=Button.new()
		b.text=pair[0]
		b.custom_minimum_size.y=55
		b.pressed.connect(session.action.bind(pair[1]))
		end.add_child(b)
	report.hide()
func refresh() -> void:
	var s: Dictionary=session.sim.state
	var p: Dictionary=s.player
	var slot: String="Yakın dövüş" if p.slot<0 else ("%s [%d]" % [p.weapons[p.slot] if p.weapons[p.slot]!="" else "boş slot",p.magazines[p.slot]])
	stats.text="MAYHEM • %s   Bölüm %d / %s   Merkez %d   HP %d   %s" % ["UNRANKED" if s.unranked else "YEREL",s.wave,MayhemCatalog.AGES[preload("res://prototype/session_rules.gd").current_age(s.wave)],s.core.hp,p.hp,slot]
	var near: Dictionary=session.sim.nearest()
	context.text="El ile kaynak topla. WASD: hareket • Sağ fare: nişan / ateş • Mobil: iki analog."
	if session.build_kind!="":
		var data: Dictionary=MayhemCatalog.BUILDINGS[session.build_kind]
		context.text="%s • %s • bölüm %d • inşa sonrası teslim" % [data.name,MayhemCatalog.resource_text(data.cost),data.wave]
	if not near.is_empty():
		context.text="%s HP:%d L%d • %s" % [MayhemCatalog.BUILDINGS[near.kind].name,near.hp,near.level,("Teslim "+MayhemCatalog.resource_text(near.delivered)) if not near.built else ("Girdi "+MayhemCatalog.resource_text(near.input)+" | Çıktı "+MayhemCatalog.resource_text(near.output if near.kind!="depot" else near.stock))]
	if s.phase=="warning": status.text="SALDIRI UYARISI %d • %s" % [ceili(s.phase_time),s.boss_id if s.boss_id!="" else "Girişleri minimap'ten izle"]
	elif p.down: status.text="YARALISIN • Sürün / klinik • Kan kaybı %.1f" % p.bleed
	else: status.text=session.message
	inventory.text="Çanta %d/30: %s%s" % [PhysicalInventory.total(p.inventory),MayhemCatalog.resource_text(p.inventory)," • Ağır kütük (yavaş)" if p.heavy else ""]
	buttons.dodge.text="Kaç %.0f" % p.dodge_cd if p.dodge_cd>0 else "Kaç / Space"
	buttons.skill.text="Yetenek %.0f" % p.skill_cd if p.skill_cd>0 else "Yetenek / C"
	menu.visible=not session.running
	report.visible=s.lost and session.running
	if s.lost:
		report_text.text="OTURUM BİTTİ\nSüre %.0f s • Rekor %d • Deneme %d\nOyuncu: %.0f hasar / %d kill\nKule/takım: %.0f hasar / %d kill\nToplama %d • Tamir %d • Üretim %d\nCheckpoint veya yeni oturum seç." % [s.stats.seconds,s.stats.peak_wave,s.stats.attempt,s.stats.player.damage,s.stats.player.kills,s.stats.team.damage,s.stats.team.kills,s.stats.player.gathered,s.stats.player.repair,s.stats.team.production]
	minimap.queue_redraw()
