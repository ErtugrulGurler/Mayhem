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
	var active: Dictionary = session.context_target()
	for source in s.sources:
		draw_circle(source.pos+Vector2(3,15),27,Color(0.15,0.28,0.2,0.18))
		ObjectGlyphs.draw(self,source.kind,source.pos,Color.WHITE)
		nameplate(source.pos+Vector2(0,42),MayhemCatalog.LABELS[source.kind].capitalize())
		if source.left>=0: label(source.pos+Vector2(26,-12),str(source.left),Color("#fff0c4"),14)
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
		var color := Color(MayhemCatalog.BUILDINGS[b.kind].color)
		if not b.built:
			draw_rect(Rect2(b.pos-Vector2(30,28),Vector2(60,56)),Color(0.95,0.85,0.65,0.35))
			for x in [-26,26]: draw_line(b.pos+Vector2(x,24),b.pos+Vector2(x,-29),Color("#9d724a"),5)
		ObjectGlyphs.draw(self,b.kind,b.pos,color)
		if b.hp<b.max_hp*0.5:
			draw_circle(b.pos-Vector2(8,36),9,Color(0.3,0.25,0.28,0.65))
			draw_circle(b.pos-Vector2(0,46),7,Color(0.3,0.25,0.28,0.5))
			draw_arc(b.pos,38,0,TAU,32,Color("#f29781"),3)
		if b.pos.distance_to(s.player.pos)<280:
			health_bar(b.pos+Vector2(0,-83),b.hp/b.max_hp,48)
			nameplate(b.pos+Vector2(0,43),MayhemCatalog.BUILDINGS[b.kind].name)
			var state_text := InteractionGuide.status(b)
			if state_text not in ["Hazır","Savunmaya hazır"]:
				nameplate(b.pos+Vector2(0,-58),state_text,Color("#ffd19a") if state_text!="Üretiliyor" else Color("#bdebaa"),12)
	for loot in s.loot:
		draw_circle(loot.pos,8,Color("#eac88e") if loot.kind not in ["heal","speed"] else Color("#f1a6a2"))
		label(loot.pos+Vector2(-16,-13),MayhemCatalog.LABELS.get(loot.kind,loot.kind),Color("#253d34"),12)
	for packet in s.packets: draw_circle(packet.pos,6,Color("#ffe087"))
	for enemy in s.enemies:
		var colors={"normal":"#d28072","runner":"#d8b468","siege":"#aa93b4","saboteur":"#8d9cb8","boss":"#c8727b"}
		var radius:=28 if enemy.kind=="boss" else 16
		draw_circle(enemy.pos+Vector2(2,6),radius,Color("#537e55"))
		ObjectGlyphs.polygon(self,[enemy.pos+Vector2(-radius,-5),enemy.pos+Vector2(-radius-5,-radius-10),enemy.pos+Vector2(-4,-radius)],Color("#57434b"))
		ObjectGlyphs.polygon(self,[enemy.pos+Vector2(radius,-5),enemy.pos+Vector2(radius+5,-radius-10),enemy.pos+Vector2(4,-radius)],Color("#57434b"))
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
	ObjectGlyphs.polygon(self,[p.pos+Vector2(-13,2),p.pos+Vector2(-20,26),p.pos+Vector2(18,24),p.pos+Vector2(12,0)],Color(profile.color).darkened(0.25))
	draw_circle(p.pos,19,Color("#364b50"))
	draw_circle(p.pos,16,Color("#aa8881") if p.down else Color(profile.color))
	draw_circle(p.pos+Vector2(-5,-3),3,Color("#fff5db"))
	draw_circle(p.pos+Vector2(5,-3),3,Color("#fff5db"))
	draw_arc(p.pos+Vector2(0,-2),18,PI,TAU,20,Color("#e3e8d4"),6)
	draw_line(p.pos,p.pos+p.aim*29,Color("#fff4d2"),4)
	if p.shot_cd>0.32 and p.slot<0:
		draw_arc(p.pos,65,p.aim.angle()-0.7,p.aim.angle()+0.7,20,Color("#ffe19d"),5)
	if p.heavy: draw_line(p.pos+Vector2(-20,-24),p.pos+Vector2(20,-24),Color("#795d47"),12)
	if p.brace>0: draw_arc(p.pos,24,0,TAU,24,Color("#abcdf3"),3)
	if not active.is_empty():
		draw_arc(active.data.pos,40,0,TAU,48,Color("#fff4af"),3)
	if session.running and not s.tutorial.skipped and s.tutorial.step<TutorialGuide.STEPS.size():
		var target: Vector2=TutorialGuide.task(s).target
		draw_arc(target,46,0,TAU,48,Color("#bdf5e9"),3)
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

func nameplate(at: Vector2,text: String,color: Color=Color("#fff3d7"),font_size: int=14) -> void:
	var width := ThemeDB.fallback_font.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size).x+12
	draw_style_box(box(Color("#365548")),Rect2(at-Vector2(width/2,16),Vector2(width,23)))
	label(at+Vector2(-width/2+6,0),text,color,font_size)
