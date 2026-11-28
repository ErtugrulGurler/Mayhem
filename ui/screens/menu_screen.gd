extends Control
@export var kind: String="home"
var flow: Node
var panel: PanelContainer
var body: VBoxContainer
var footer: HBoxContainer
var heading: Label
var note: Label
var buttons: Dictionary={}
var cards: Array[Button]=[]
var preview: Control
var scale_choice: OptionButton
var effects_choice: OptionButton
var layout_signature:=Vector4(-1,-1,-1,-1)
var zoom: HSlider
var scroll: ScrollContainer

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	theme=MenuTheme.create()
	panel=PanelContainer.new()
	add_child(panel)
	var column:=VBoxContainer.new()
	column.add_theme_constant_override("separation",10)
	panel.add_child(column)
	heading=MenuTheme.label(column,title(),26)
	heading.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	scroll=ScrollContainer.new()
	scroll.size_flags_vertical=Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
	column.add_child(scroll)
	body=VBoxContainer.new()
	body.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation",10)
	scroll.add_child(body)
	footer=HBoxContainer.new()
	footer.add_theme_constant_override("separation",12)
	column.add_child(footer)
	if kind!="home": add_button(footer,"Geri",flow.back,"back")
	match kind:
		"home": home()
		"character": characters()
		"map": map_setup()
		"summary": summary()
		"confirm": confirmation()
		"settings": settings()
		"statistics": statistics()
		"pause": pause()
		"controls": controls()
		"defeat": defeat()
	note=MenuTheme.label(column,flow.notice,15)
	note.modulate=Color("#ffe09b")
	note.visible=not flow.notice.is_empty()
	footer.visible=footer.get_child_count()>0 and kind not in ["home","pause","defeat"]
	layout()
	get_viewport().size_changed.connect(layout)
	call_deferred("focus_first")

func title() -> String:
	return {"home":"","character":"Yeni Oyun · Karakterini seç","map":"Orman / Çayır · Merkez konumu","summary":"Savunmaya hazır mısın?","confirm":"Kayıtlı bir oturum var",
		"settings":"Ayarlar","statistics":"İstatistikler","pause":"Oyun duraklatıldı","controls":"Kontroller","defeat":"Savunma sona erdi"}.get(kind,"Mayhem")

func add_button(parent: Node,text: String,callback: Callable,id: String="",primary: bool=false) -> Button:
	var button:=MenuTheme.button(parent,text,callback,primary)
	button.size_flags_horizontal=Control.SIZE_EXPAND_FILL
	if id!="": buttons[id]=button
	return button

func home() -> void:
	heading.hide()
	add_button(body,"Yeni Oyun",flow.new_setup,"new",true)
	var resume:=add_button(body,"Devam Et",flow.resume_saved,"continue")
	var valid:=MenuData.suspend(flow.suspend_path)
	resume.disabled=valid.is_empty()
	if valid.is_empty():
		MenuTheme.label(body,"Kayıt okunamadı. Yeni oyun başlatabilir veya kaydı kontrol edebilirsin." if FileAccess.file_exists(flow.suspend_path) else "Devam edilecek kayıt yok",14)
	var coop:=add_button(body,"Arkadaşlarla Oyna",func(): pass,"friends")
	coop.disabled=true
	MenuTheme.label(body,"Geliştiriliyor · Gerçek co-op henüz yok",14)
	add_button(body,"İstatistikler",flow.navigate.bind("statistics"),"statistics")
	add_button(body,"Ayarlar",flow.navigate.bind("settings"),"settings")

func characters() -> void:
	MenuTheme.label(body,"Tek Oyunculu · Çok Oyunculu geliştiriliyor",16)
	var grid:=GridContainer.new()
	grid.columns=2
	grid.add_theme_constant_override("h_separation",12)
	grid.add_theme_constant_override("v_separation",12)
	body.add_child(grid)
	var styles=["Pip · Darbeleri göğüsler","Hızlı hareket eder · depar","Savunmada dayanır · siper","Kendini iyileştirir · sargı"]
	var skills={"shockwave":"Alan darbesi","sprint":"Depar","brace":"Siper","bandage":"Sargı"}
	for i in range(MayhemCatalog.CHARACTERS.size()):
		var data: Dictionary=MayhemCatalog.CHARACTERS[i]
		var card:=add_button(grid,"",select_character.bind(i),"character_"+str(i))
		card.custom_minimum_size=Vector2(340,140)*UserPreferences.ui_scale
		cards.append(card)
		var row:=HBoxContainer.new()
		row.mouse_filter=Control.MOUSE_FILTER_IGNORE
		row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		row.offset_left=10; row.offset_top=8; row.offset_right=-10; row.offset_bottom=-8
		card.add_child(row)
		var portrait:=preload("res://ui/art/character_portrait.gd").new()
		portrait.character=i
		portrait.custom_minimum_size=Vector2(76,108)
		row.add_child(portrait)
		var info:=VBoxContainer.new()
		info.mouse_filter=Control.MOUSE_FILTER_IGNORE
		info.size_flags_horizontal=Control.SIZE_EXPAND_FILL
		row.add_child(info)
		var name_label:=MenuTheme.label(info,data.name,19)
		name_label.add_theme_color_override("font_color",MenuTheme.FOREST)
		var detail:=MenuTheme.label(info,"%s\nHP %d · Hız %d · Yakın darbe %d\nYetenek: %s" % [styles[i],data.hp,data.speed,data.melee,skills[data.skill]],14)
		detail.add_theme_color_override("font_color",MenuTheme.FOREST)
	select_character(flow.draft.character)
	add_button(footer,"Devam",flow.navigate.bind("map"),"next",true)

func select_character(index: int) -> void:
	flow.draft.character=index
	for i in range(cards.size()):
		cards[i].add_theme_stylebox_override("normal",MenuTheme.box(Color("#ffe4a3") if i==index else Color("#cdbf99"),Color("#f6bd55") if i==index else Color("#726c49")))
		cards[i].tooltip_text="Seçili" if i==index else "Karakteri seç"

func map_setup() -> void:
	MenuTheme.label(body,"Orman / Çayır · Uygulanmış tek harita. Köprülü geçit ve elle kaynak taşıma.",18)
	preview=preload("res://ui/art/map_preview.gd").new()
	preview.location=flow.draft.location; preview.variation=flow.draft.variation
	body.add_child(preview)
	var row:=HBoxContainer.new()
	row.add_theme_constant_override("separation",12)
	body.add_child(row)
	for field in ["location","variation"]:
		var choice:=OptionButton.new()
		choice.custom_minimum_size=Vector2(0,MenuTheme.touch_height(self))
		choice.size_flags_horizontal=Control.SIZE_EXPAND_FILL
		if field=="location":
			choice.add_item("Merkez · Batı çayırı"); choice.add_item("Merkez · Doğu çayırı")
		else: choice.add_item("Varyasyon A"); choice.add_item("Varyasyon B")
		choice.select(flow.draft[field])
		choice.item_selected.connect(func(index):
			flow.draft[field]=index
			preview.location=flow.draft.location; preview.variation=flow.draft.variation; preview.queue_redraw())
		row.add_child(choice)
	MenuTheme.label(body,"Başlangıçta yalnız merkez vardır. Duvar, fabrika ve ekipman verilmez. Kanyon ve bataklık ileriki kapsamdır.",17)
	add_button(footer,"Devam",flow.navigate.bind("summary"),"next",true)

func summary() -> void:
	var data: Dictionary=MayhemCatalog.CHARACTERS[flow.draft.character]
	MenuTheme.label(body,"Tek Oyuncu\n%s\nOrman / Çayır\nMerkez: %s · Varyasyon %s" % [data.name,"Batı" if flow.draft.location==0 else "Doğu","A" if flow.draft.variation==0 else "B"],23)
	MenuTheme.label(body,"Boş çantayla başlarsın. İlk malzemeleri elinle toplayıp tesisleri kendin kuracaksın. Oyun içi rehber yardımcı olur.",18)
	add_button(footer,"Başlat",flow.request_start,"start",true)

func confirmation() -> void:
	MenuTheme.label(body,"Eski oturumu silip yeni oyun başlat",24)
	MenuTheme.label(body,"Mevcut ara verme kaydı silinecek. Yeni oturum sıfırdan başlayacak. İptal edersen kaydın korunur.",19)
	buttons.back.text="İptal"
	add_button(footer,"Eski oturumu sil ve başlat",flow.commit_new,"confirm",true)

func settings() -> void:
	MenuTheme.label(body,"UI ölçeği · Yazılar ve dokunma hedefleri",18)
	scale_choice=OptionButton.new()
	for text in ["Küçük","Normal","Büyük"]: scale_choice.add_item(text)
	scale_choice.selected=0 if UserPreferences.ui_scale<1 else (2 if UserPreferences.ui_scale>1 else 1)
	scale_choice.custom_minimum_size.y=MenuTheme.touch_height(self)
	body.add_child(scale_choice)
	MenuTheme.label(body,"Dekoratif efektler",18)
	effects_choice=OptionButton.new()
	effects_choice.add_item("Normal · Yaprak ve duman"); effects_choice.add_item("Düşük · Durağan dekor")
	effects_choice.selected=1 if UserPreferences.low_effects else 0
	effects_choice.custom_minimum_size.y=MenuTheme.touch_height(self)
	body.add_child(effects_choice)
	MenuTheme.label(body,"Oyun kamerası yakınlığı",18)
	zoom=HSlider.new()
	zoom.min_value=0.7; zoom.max_value=2.0; zoom.step=0.1; zoom.value=UserPreferences.camera_zoom
	zoom.custom_minimum_size.y=MenuTheme.touch_height(self)
	body.add_child(zoom)
	MenuTheme.label(body,"Ses altyapısı henüz yok; işlevsiz bir ses ayarı sunulmaz.",15)
	add_button(footer,"Uygula ve kaydet",apply_settings,"apply",true)

func apply_settings() -> void:
	UserPreferences.ui_scale=[0.9,1.0,1.1][scale_choice.selected]
	UserPreferences.low_effects=effects_choice.selected==1
	UserPreferences.camera_zoom=zoom.value
	if not UserPreferences.save_settings(): flow.notice="Ayarlar diske kaydedilemedi."; note.text=flow.notice; note.show(); return
	flow.apply_preferences()
	flow.notice="Ayarlar kaydedildi."
	flow.show_page("settings")

func statistics() -> void:
	var actual:=MenuData.statistics()
	if actual.is_empty(): MenuTheme.label(body,"Henüz kayıtlı istatistik yok",22); return
	var s: Dictionary=actual.stats
	MenuTheme.label(body,"%s\nAktif süre: %.0f sn · En yüksek bölüm: %d · Deneme: %d" % [actual.reason,s.seconds,s.peak_wave,s.attempt],21)
	MenuTheme.label(body,"Oyuncu doğrudan hasarı: %.0f · Öldürme: %d\nKule / takım hasarı: %.0f · Öldürme: %d\nToplanan kaynak: %d · Onarım: %d · Takım üretimi: %d" % [s.player.damage,s.player.kills,s.team.damage,s.team.kills,s.player.gathered,s.player.repair,s.team.production],18)
	MenuTheme.label(body,"Son gerçek oturum kaydıdır; online leaderboard veya kalıcı güç sistemi değildir.",15)

func pause() -> void:
	buttons.back.text="Oyuna Dön"
	add_button(body,"Oyuna Dön",flow.resume_game,"return",true)
	add_button(body,"Kaydet ve Ana Menü",flow.save_and_home,"save")
	add_button(body,"Ayarlar",flow.navigate.bind("settings"))
	add_button(body,"Kontroller",flow.navigate.bind("controls"))
	add_button(body,"Rehberi Göster",flow.show_tutorial)
	add_button(body,"Geliştirici araçları",flow.developer)

func controls() -> void:
	MenuTheme.label(body,"Sol analog: hareket\nSağ analog: tuttuğun yöne otomatik saldırı\nKaç ve Yetenek: ayrı düğmeler · Nişan yardımı yok\nİnşa / Çanta / yakındaki nesne: alt düğmeler",21)
	MenuTheme.label(body,"Masaüstü: WASD hareket, sağ fare nişan.\nE etkileşim · F yükle · G ürün al · R doldur\nQ silah · Space kaç · C yetenek · H medkit\nEsc / Android Geri: geri git veya oyunu duraklat.",18)

func defeat() -> void:
	var s: Dictionary=flow.game.sim.state.stats
	MenuTheme.label(body,"Merkez veya karakter kaybedildi.\nSüre %.0f sn · Rekor %d · Deneme %d\nSen: %.0f hasar · Kule/takım: %.0f hasar" % [s.seconds,s.peak_wave,s.attempt,s.player.damage,s.team.damage],21)
	buttons.back.text="Ana Menü"
	add_button(body,"Checkpoint'ten tekrar dene",flow.retry_checkpoint,"retry",true)
	add_button(body,"Yeni Oyun",flow.new_setup,"new")
	add_button(body,"Ana Menü",flow.home_after_defeat,"home")

func focus_first() -> void:
	if not is_inside_tree(): return
	if kind=="confirm" and buttons.has("back"):
		buttons.back.grab_focus()
		return
	for button in buttons.values():
		if button.is_visible_in_tree() and not button.disabled and button.get_meta("primary",false):
			button.grab_focus()
			return
	for button in buttons.values():
		if button.is_visible_in_tree() and not button.disabled: button.grab_focus(); return

func layout() -> void:
	var safe:=MenuTheme.safe_bounds(get_viewport())
	var viewport_size:=safe.size
	if kind=="home":
		panel.position=safe.position+Vector2(viewport_size.x*0.66,viewport_size.y*0.12)
		panel.size=Vector2(viewport_size.x*0.31,viewport_size.y*0.84)
	else:
		panel.size=Vector2(minf(880,viewport_size.x-48),viewport_size.y-40)
		panel.position=safe.position+(viewport_size-panel.size)/2

func _process(_dt: float) -> void:
	if not is_instance_valid(panel): return
	var viewport_size:=get_viewport_rect().size
	var minimum:=panel.get_combined_minimum_size()
	var signature:=Vector4(viewport_size.x,viewport_size.y,minimum.x,minimum.y)
	if signature!=layout_signature:
		layout_signature=signature
		layout()
