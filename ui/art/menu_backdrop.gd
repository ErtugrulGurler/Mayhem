extends Control
## Original procedural 2D layers. The isometric pedestal is decorative menu art only.
var clock:=0.0
var pulse:=0.0
var core_position:=Vector2.ZERO
func _ready() -> void:
	mouse_filter=Control.MOUSE_FILTER_PASS
func _process(dt: float) -> void:
	if not UserPreferences.low_effects: clock+=dt
	var was_pulse:=pulse
	pulse=maxf(0,pulse-dt*2)
	if not UserPreferences.low_effects or was_pulse>0: queue_redraw()
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.position.distance_to(core_position)<110:
		pulse=1.0
		queue_redraw()
		accept_event()
func poly(points: Array,color: Color) -> void:
	draw_colored_polygon(PackedVector2Array(points),color)
func _draw() -> void:
	var s:=size
	draw_rect(Rect2(Vector2.ZERO,s),Color("#264f3c"))
	for band in range(3):
		var y: float=s.y*(0.40+band*0.18)
		var points: Array=[Vector2(0,s.y),Vector2(0,y)]
		for i in range(11): points.append(Vector2(i*s.x/10,y+sin(i*1.4+band)*35))
		points.append(Vector2(s.x,s.y))
		poly(points,[Color("#3d6947"),Color("#56804b"),Color("#76934d")][band])
	for side in [0,1]:
		for i in range(5):
			var x: float=20+i*74 if side==0 else s.x-i*60
			var y: float=s.y*(0.27+i*0.07)
			draw_line(Vector2(x,y),Vector2(x,s.y),Color("#214331"),18)
			for offset in [Vector2(-16,-20),Vector2(15,-15),Vector2(0,-40)]:
				draw_circle(Vector2(x,y)+offset,45,Color("#224f37"))
				draw_circle(Vector2(x,y)+offset-Vector2(4,5),35,Color("#3c7043"))
	for i in range(0 if UserPreferences.low_effects else 14):
		var x: float=fmod(i*137.0+clock*6,s.x)
		var y: float=s.y*0.35+fmod(i*59.0+sin(clock+i)*12,s.y*0.6)
		draw_circle(Vector2(x,y),2.5,Color(0.95,0.84,0.46,0.4))
	core_position=Vector2(s.x*0.34,s.y*0.65)
	var scale_factor:=minf(s.x/960,s.y/540)
	draw_set_transform(core_position,0,Vector2.ONE*scale_factor)
	draw_set_transform(core_position+Vector2(0,95)*scale_factor,0,Vector2(1,0.25)*scale_factor)
	draw_circle(Vector2.ZERO,160,Color(0.08,0.19,0.11,0.4))
	draw_set_transform(core_position,0,Vector2.ONE*scale_factor)
	# Thick side faces, lit top, masonry plinth and wooden braces.
	poly([Vector2(-145,45),Vector2(0,112),Vector2(145,45),Vector2(145,76),Vector2(0,142),Vector2(-145,76)],Color("#635b40"))
	poly([Vector2(-145,45),Vector2(0,-18),Vector2(145,45),Vector2(0,112)],Color("#d0c191"))
	draw_polyline(PackedVector2Array([Vector2(-145,45),Vector2(0,112),Vector2(145,45)]),Color("#ead5a1"),4,true)
	poly([Vector2(-73,-64),Vector2(0,-95),Vector2(73,-64),Vector2(73,38),Vector2(0,76),Vector2(-73,38)],Color("#45594c"))
	poly([Vector2(-73,-64),Vector2(0,-31),Vector2(73,-64),Vector2(0,-95)],Color("#b4bc9c"))
	poly([Vector2(-73,-64),Vector2(0,-31),Vector2(0,76),Vector2(-73,38)],Color("#778574"))
	poly([Vector2(0,-31),Vector2(73,-64),Vector2(73,38),Vector2(0,76)],Color("#596d5b"))
	for y in [53,74]:
		draw_line(Vector2(-130,y),Vector2(-12,y+58),Color("#a08f63"),2)
	for x in [-104,-60,-18]:
		draw_line(Vector2(x,68+(x+104)*0.4),Vector2(x,88+(x+104)*0.4),Color("#453e30"),2)
	draw_line(Vector2(-66,-37),Vector2(-9,-11),Color("#b7b694"),4)
	draw_line(Vector2(-66,17),Vector2(-9,45),Color("#485b4b"),4)
	for bolt_pos in [Vector2(-60,-48),Vector2(-13,-26),Vector2(60,-48),Vector2(12,-26)]:
		draw_circle(bolt_pos,4,Color("#e4c985"))
	for side in [-1,1]:
		draw_line(Vector2(side*102,53),Vector2(side*88,-63),Color("#624733"),22)
		draw_line(Vector2(side*104,49),Vector2(side*91,-64),Color("#b48b4d"),12)
		draw_circle(Vector2(side*91,-48),5,Color("#ded0a5"))
	poly([Vector2(-44,-26),Vector2(0,-6),Vector2(43,-26),Vector2(43,25),Vector2(0,48),Vector2(-44,25)],Color("#293f36"))
	draw_circle(Vector2(0,10),27+pulse*5,Color("#d59243"))
	draw_circle(Vector2(0,10),19+pulse*4,Color("#ffca6d"))
	draw_circle(Vector2(-4,3),10,Color("#fff0b3"))
	draw_line(Vector2(-48,-38),Vector2(0,-15),Color("#d2bd80"),5)
	draw_line(Vector2(0,-15),Vector2(48,-38),Color("#d2bd80"),5)
	draw_rect(Rect2(21,-121,25,40),Color("#3f5349"))
	draw_rect(Rect2(17,-126,33,10),Color("#bcc09b"))
	if not UserPreferences.low_effects:
		for i in range(3):
			var rise:=fmod(clock*16+i*18,60)
			draw_circle(Vector2(32+sin(clock+i)*8,-127-rise),8+rise/9,Color(0.81,0.81,0.65,0.35*(1-rise/60)))
	draw_set_transform(Vector2.ZERO)
	var logo:="MAYHEM"
	var font:=ThemeDB.fallback_font
	var font_size:=roundi(74*scale_factor)
	var width:=font.get_string_size(logo,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size).x
	var at:=Vector2(s.x*0.34-width/2,s.y*0.17)
	draw_string_outline(font,at+Vector2(2,5),logo,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,10,Color("#553f27"))
	draw_string(font,at,logo,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,Color("#ffeac0"))
	var slogan:="Topla. İnşa et. Üret. Savun."
	var small:=roundi(20*scale_factor)
	width=font.get_string_size(slogan,HORIZONTAL_ALIGNMENT_LEFT,-1,small).x
	draw_string(font,Vector2(s.x*0.34-width/2,s.y*0.24),slogan,HORIZONTAL_ALIGNMENT_LEFT,-1,small,Color("#f5dda4"))
