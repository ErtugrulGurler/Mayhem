extends Node2D
var session: Node
func label(at: Vector2,text: String,color: Color=Color("#fff4d6"),size: int=15) -> void:
	draw_string(ThemeDB.fallback_font,at,text,HORIZONTAL_ALIGNMENT_LEFT,-1,size,color)
func _draw() -> void:
	if session==null: return
	var s: Dictionary=session.sim.state
	draw_rect(Rect2(Vector2.ZERO,MayhemCatalog.SIZE),Color("#78ac70"))
	for x in range(40,1800,90):
		for y in range(30,1200,90):
			draw_circle(Vector2(x,y),3,Color("#91bd7a"))
	for rect in [Rect2(850,0,100,460),Rect2(850,740,100,460)]:
		draw_rect(rect.grow(10),Color("#d6bd85"))
		draw_rect(rect,Color("#639db7"))
	draw_rect(Rect2(850,460,100,280),Color("#b6aa79"))
	for y in range(470,740,22): draw_line(Vector2(850,y),Vector2(950,y),Color("#8c9066"),3)
	draw_rect(Rect2(1260,150,140,180),Color("#7b8c83"))
	label(Vector2(1267,175),"UÇURUM")
	for source in s.sources:
		var colors={"wood":Color("#417e50"),"stone":Color("#b5bbb0"),"ore":Color("#af897a"),"rare":Color("#bf94cf"),"heavy":Color("#916c49")}
		draw_circle(source.pos+Vector2(3,6),26,Color("#5e8c5a"))
		draw_circle(source.pos,24,colors[source.kind])
		label(source.pos+Vector2(-28,40),MayhemCatalog.LABELS[source.kind])
		if source.left>=0: label(source.pos+Vector2(-8,5),str(source.left))
	draw_circle(s.core.pos+Vector2(0,8),47,Color("#476e50"))
	draw_circle(s.core.pos,37,Color("#e4d29e"))
	draw_circle(s.core.pos,23,Color("#eea65c"))
	draw_colored_polygon(PackedVector2Array([s.core.pos+Vector2(-13,8),s.core.pos+Vector2(0,-33),s.core.pos+Vector2(16,8)]),Color("#ffe997"))
	label(s.core.pos+Vector2(-30,65),"MERKEZ")
	health_bar(s.core.pos+Vector2(0,-55),s.core.hp/s.core.max_hp,65)
	for b in s.structures:
		if b.kind in ["cable","conveyor"] and b.links.size()>0:
			for id in b.links:
				for other in s.structures:
					if other.id==id:
						draw_line(b.pos,other.pos,Color("#f9d36f") if b.kind=="cable" else Color("#547e85"),5)
		var color:=Color(MayhemCatalog.BUILDINGS[b.kind].color)
		if not b.built: color.a=0.5
		draw_style_box(box(color),Rect2(b.pos-Vector2(26,24),Vector2(52,48)))
		draw_circle(b.pos-Vector2(9,7),8,Color("#fff0ca"))
		if b.kind=="turret":
			draw_line(b.pos,b.pos+Vector2(27,-8),Color("#4e6070"),9)
		if b.kind=="smelter": draw_circle(b.pos,11,Color("#f48952"))
		if b.kind=="clinic":
			draw_line(b.pos-Vector2(9,0),b.pos+Vector2(9,0),Color("#fff6ea"),5)
			draw_line(b.pos-Vector2(0,9),b.pos+Vector2(0,9),Color("#fff6ea"),5)
		if b.hp<b.max_hp*0.5: draw_circle(b.pos-Vector2(0,26),10,Color(0.28,0.24,0.25,0.6))
		if b.pos.distance_to(s.player.pos)<260:
			health_bar(b.pos+Vector2(0,-36),b.hp/b.max_hp,48)
			label(b.pos+Vector2(-30,45),MayhemCatalog.BUILDINGS[b.kind].name,Color("#253d34"),14)
			if not b.built:
				label(b.pos+Vector2(-26,60),"%.1f s" % b.progress,Color("#253d34"),13)
			elif b.kind in ["generator","electric_bench","cable"]:
				label(b.pos+Vector2(-24,60),"ENERJİ" if b.powered else "KESİK",Color("#253d34"),13)
	for loot in s.loot:
		draw_circle(loot.pos,8,Color("#eac88e") if loot.kind not in ["heal","speed"] else Color("#f1a6a2"))
		label(loot.pos+Vector2(-16,-13),MayhemCatalog.LABELS.get(loot.kind,loot.kind),Color("#253d34"),12)
	for packet in s.packets: draw_circle(packet.pos,6,Color("#ffe087"))
	for enemy in s.enemies:
		var colors={"normal":"#d28072","runner":"#d8b468","siege":"#aa93b4","saboteur":"#8d9cb8","boss":"#c8727b"}
		var radius:=28 if enemy.kind=="boss" else 16
		draw_circle(enemy.pos+Vector2(2,6),radius,Color("#537e55"))
		draw_circle(enemy.pos,radius+2,Color("#544957"))
		draw_circle(enemy.pos,radius,Color.WHITE if enemy.flash>0 else Color(colors[enemy.kind]))
		draw_circle(enemy.pos+Vector2(-5,-3),4,Color("#fff7d9"))
		draw_circle(enemy.pos+Vector2(5,-3),4,Color("#fff7d9"))
		draw_circle(enemy.pos+Vector2(-4,-3),2,Color("#333542"))
		draw_circle(enemy.pos+Vector2(6,-3),2,Color("#333542"))
		health_bar(enemy.pos+Vector2(0,-radius-10),enemy.hp/enemy.max_hp,32)
	for shot in s.projectiles: draw_line(shot.pos,shot.pos-shot.dir*13,Color("#fff3ab"),4)
	var p: Dictionary=s.player
	var profile: Dictionary=MayhemCatalog.CHARACTERS[p.character]
	draw_circle(p.pos+Vector2(0,8),20,Color("#537e55"))
	draw_circle(p.pos,19,Color("#364b50"))
	draw_circle(p.pos,16,Color("#aa8881") if p.down else Color(profile.color))
	draw_circle(p.pos+Vector2(-5,-3),3,Color("#fff5db"))
	draw_circle(p.pos+Vector2(5,-3),3,Color("#fff5db"))
	draw_line(p.pos,p.pos+p.aim*29,Color("#fff4d2"),4)
	if p.shot_cd>0.32 and p.slot<0:
		draw_arc(p.pos,65,p.aim.angle()-0.7,p.aim.angle()+0.7,20,Color("#ffe19d"),5)
	if p.heavy: draw_line(p.pos+Vector2(-20,-24),p.pos+Vector2(20,-24),Color("#795d47"),12)
	if p.brace>0: draw_arc(p.pos,24,0,TAU,24,Color("#abcdf3"),3)
	if session.build_kind!="" and session.running:
		var ghost: Vector2=BuildingSystem.snap(s,session.ghost)
		var tint:=Color(0.7,1,0.7,0.5) if BuildingSystem.can_place(s,session.build_kind,ghost) else Color(1,0.4,0.4,0.5)
		draw_rect(Rect2(ghost-Vector2(28,28),Vector2(56,56)),tint)
func health_bar(at: Vector2,ratio: float,width: float) -> void:
	draw_rect(Rect2(at-Vector2(width/2,0),Vector2(width,5)),Color("#4b4d44"))
	draw_rect(Rect2(at-Vector2(width/2,0),Vector2(width*clampf(ratio,0,1),5)),Color("#b8e990"))
func box(color: Color) -> StyleBoxFlat:
	var style:=StyleBoxFlat.new()
	style.bg_color=color
	style.border_color=Color("#4e6354")
	style.set_border_width_all(3)
	style.set_corner_radius_all(8)
	return style
