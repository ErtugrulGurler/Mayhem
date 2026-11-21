extends SceneTree
var checks:=0
var failures:=0
func check(ok: bool,text: String) -> void:
	checks+=1
	if ok: print("PASS ",text)
	else: failures+=1; push_error(text)
func gather(node: Node,items: Array) -> void:
	if node is Button and node.is_visible_in_tree():
		var rect: Rect2=node.get_global_rect()
		var parent: Node=node.get_parent()
		while parent is Control:
			if parent.clip_contents: rect=rect.intersection(parent.get_global_rect())
			parent=parent.get_parent()
		if rect.has_area(): items.append({"control":node,"rect":rect})
	for child in node.get_children(): gather(child,items)
func validate(app: Node,viewport_size: Vector2) -> void:
	var items: Array=[]
	gather(app.page,items)
	var in_bounds:=true
	var overlap:=false
	var hit_size:=true
	var forbidden:=false
	for item in items:
		if not Rect2(Vector2.ZERO,viewport_size).encloses(item.rect):
			in_bounds=false
			print("OUTSIDE ",app.page_name,item.control.text,item.rect," panel ",app.page.panel.get_rect())
		if item.control.size.y<48 or item.control.size.x<48: hit_size=false
		if item.control.text.to_lower() in ["quit","exit","çıkış","bölüm seç"]: forbidden=true
	for i in range(items.size()):
		for j in range(i+1,items.size()):
			if items[i].rect.intersects(items[j].rect):
				overlap=true
				print("OVERLAP ",app.page_name,items[i].control.text," / ",items[j].control.text)
	check(in_bounds,"MM-017 "+app.page_name+" in bounds "+str(viewport_size))
	check(not overlap,"MM-017 "+app.page_name+" no overlapping hit regions")
	check(hit_size,"MM-017 "+app.page_name+" minimum 48 logical-pixel targets")
	check(not forbidden,"MM-012 no Quit/Exit/level select")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	for dimension in [Vector2i(960,540),Vector2i(1920,1080),Vector2i(2340,1080),Vector2i(2400,1080)]:
		for scale_value in [0.9,1.0,1.1]:
			var viewport:=SubViewport.new()
			viewport.size=dimension
			root.add_child(viewport)
			var app=load("res://ui/main_menu.tscn").instantiate()
			viewport.add_child(app)
			await process_frame
			UserPreferences.ui_scale=scale_value
			app.show_page("home")
			for kind in ["home","character","map","summary","confirm","settings","statistics","controls"]:
				app.show_page(kind)
				await process_frame; await process_frame
				validate(app,Vector2(dimension))
			app.commit_new()
			app.game.set_process(false)
			app.game.hud.show_panel("build")
			await process_frame; await process_frame
			var hud_items: Array=[]
			gather(app.game.hud.root,hud_items)
			var hud_inside:=true
			var hud_overlap:=false
			for item in hud_items:
				if not Rect2(Vector2.ZERO,Vector2(dimension)).encloses(item.rect): hud_inside=false
			for i in range(hud_items.size()):
				for j in range(i+1,hud_items.size()):
					if hud_items[i].rect.intersects(hud_items[j].rect): hud_overlap=true
			check(hud_inside,"MM-017 scaled gameplay panel in bounds")
			check(not hud_overlap,"MM-017 scaled gameplay panel buttons do not overlap")
			check(not app.game.hud.panel_close.get_rect().intersects(app.game.hud.panel_info.get_rect()),"MM-017 panel text does not overlap close button")
			app.game.hud.close_panel()
			app.pause_game()
			await process_frame; await process_frame
			validate(app,Vector2(dimension))
			app.game.sim.state.lost=true
			app.show_defeat()
			await process_frame; await process_frame
			validate(app,Vector2(dimension))
			viewport.queue_free()
			await process_frame
	UserPreferences.ui_scale=1.0
	print("MENU LAYOUT: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
