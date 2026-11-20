extends SceneTree
var failures:=0
var checks:=0
func check(ok: bool,text: String) -> void:
	checks+=1
	if ok: print("PASS ",text)
	else: failures+=1; push_error(text)
func visible_buttons(node: Node, result: Array) -> void:
	if node is Button and node.is_visible_in_tree():
		var rect: Rect2=node.get_global_rect()
		var parent: Node=node.get_parent()
		var clipped:=rect
		while parent is Control:
			if parent.clip_contents: clipped=clipped.intersection(parent.get_global_rect())
			parent=parent.get_parent()
		if clipped.has_area(): result.append({"node":node,"rect":clipped})
	for child in node.get_children(): visible_buttons(child,result)
func validate(hud: Node,size: Vector2,stage: String) -> void:
	var items: Array=[]
	visible_buttons(hud.root,items)
	var inside:=true
	var overlap:=false
	var touch_size:=true
	for item in items:
		if not Rect2(Vector2.ZERO,size).encloses(item.rect): inside=false
		if item.node.size.x<48 or item.node.size.y<48: touch_size=false
	for i in range(items.size()):
		for j in range(i+1,items.size()):
			if items[i].rect.intersects(items[j].rect):
				overlap=true
				print("OVERLAP ",items[i].node.text," / ",items[j].node.text,items[i].rect,items[j].rect)
	check(inside,stage+" buttons stay inside "+str(size))
	check(not overlap,stage+" button hit regions do not overlap")
	check(touch_size,stage+" all targets at least 48x48 logical pixels")
	if stage=="normal":
		check(items.size()<=8,"Normal HUD has at most eight visible buttons")
		check(hud.is_world_point(size/2),"Gameplay center is free")
		var reserved: float=(size.x-16)*50+2*152*152+140*94
		if hud.mission.visible: reserved+=hud.mission.get_rect().get_area()
		if hud.toast.visible: reserved+=hud.toast.get_rect().get_area()
		for button in hud.dock: reserved+=button.get_rect().get_area()
		check(reserved/(size.x*size.y)<0.45,"At least 55 percent of the viewport remains outside HUD footprints")
	else:
		if hud.panel.visible:
			for center in hud.session.router.centers:
				check(not hud.panel.get_rect().intersects(Rect2(center-Vector2(76,76),Vector2(152,152))),"Panel does not intersect analog region")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	for size in [Vector2i(960,540),Vector2i(1200,540),Vector2i(960,720)]:
		var viewport:=SubViewport.new()
		viewport.size=size
		viewport.handle_input_locally=true
		root.add_child(viewport)
		var game=load("res://prototype/scenes/session.tscn").instantiate()
		viewport.add_child(game)
		await process_frame
		await process_frame
		game.set_process(false)
		game.hud.layout(Vector2(size))
		game.hud.refresh()
		await process_frame
		validate(game.hud,Vector2(size),"start")
		game.action("new")
		await process_frame
		validate(game.hud,Vector2(size),"normal")
		game.sim.state.player.slot=0
		game.sim.state.player.weapons[0]="bow"
		game.refresh_ui()
		await process_frame
		validate(game.hud,Vector2(size),"ranged")
		check(game.hud.controls.reload.visible,"Ranged equipment exposes quick reload")
		var analog: Vector2=game.router.centers[1]
		check(not game.hud.controls.reload.get_rect().intersects(Rect2(analog-Vector2(76,76),Vector2(152,152))),"Reload does not overlap aim pad")
		for panel in ["build","inventory","options","developer"]:
			game.hud.show_panel(panel)
			await process_frame
			await process_frame
			validate(game.hud,Vector2(size),panel)
		game.hud.close_panel()
		game.sim.state.player.pos=Vector2(700,670)
		var b:=MayhemCatalog.building("ammo_bench",Vector2(700,600),1)
		b.built=true
		game.sim.state.structures.append(b)
		game.selection={"type":"building","data":b}
		game.hud.show_panel("object")
		await process_frame
		await process_frame
		validate(game.hud,Vector2(size),"object")
		game.hud.confirm_dismantle()
		await process_frame
		await process_frame
		validate(game.hud,Vector2(size),"confirm")
		game.hud.close_panel()
		game.sim.state.lost=true
		game.refresh_ui()
		await process_frame
		validate(game.hud,Vector2(size),"defeat")
		viewport.queue_free()
		await process_frame
	print("LAYOUT: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
