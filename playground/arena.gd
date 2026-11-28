extends Node2D

const PropScene = preload("res://playground/world_prop.gd")
const WORLD_SIZE := Vector2(2400, 1600)
@onready var player: CharacterBody2D = $Actors/Player
@onready var controls: Node = $InputRouter

func _ready() -> void:
	# Static, deterministic layout; the spawn and trail are always unobstructed.
	var trees := [Vector2(170, 340), Vector2(370, 240), Vector2(650, 460), Vector2(890, 570), Vector2(1120, 520), Vector2(1480, 390), Vector2(1770, 310), Vector2(2100, 270), Vector2(2270, 840), Vector2(2040, 1050), Vector2(1730, 1180), Vector2(1440, 1080), Vector2(1010, 1230), Vector2(620, 1340), Vector2(300, 1310), Vector2(180, 740), Vector2(2180, 1390)]
	for i in range(trees.size()): add_prop("tree", trees[i], i)
	for point in [Vector2(1040, 780), Vector2(1450, 900), Vector2(670, 710), Vector2(1690, 570), Vector2(1900, 890), Vector2(440, 1130), Vector2(800, 1100)]:
		add_prop("rock", point, 0)
	add_prop("sign", Vector2(1340, 785), 0)
	add_boundary(Rect2(-40, -40, WORLD_SIZE.x + 80, 60))
	add_boundary(Rect2(-40, WORLD_SIZE.y - 20, WORLD_SIZE.x + 80, 60))
	add_boundary(Rect2(-40, 0, 60, WORLD_SIZE.y))
	add_boundary(Rect2(WORLD_SIZE.x - 20, 0, 60, WORLD_SIZE.y))
	$Actors/Player/Camera.reset_smoothing()
	setup_combat()
	$Actors/Player/Camera.zoom = Vector2.ONE * UserPreferences.camera_zoom
	get_tree().root.go_back_requested.connect(leave)

func add_prop(kind: String, at: Vector2, variant: int) -> void:
	var prop := StaticBody2D.new()
	prop.set_script(PropScene)
	prop.kind = kind
	prop.variant = variant
	prop.position = at
	$Actors.add_child(prop)

func add_boundary(rect: Rect2) -> void:
	var wall := StaticBody2D.new()
	wall.name = "Boundary"
	wall.position = rect.get_center()
	wall.collision_layer = 1
	wall.collision_mask = 2
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	var collision := CollisionShape2D.new()
	collision.shape = shape
	wall.add_child(collision)
	add_child(wall)

const Gear = [null,preload("res://assets/equipment/pistol.svg"),preload("res://assets/equipment/rifle.svg"),preload("res://assets/equipment/axe.svg")]
const DELAYS = [0.0,0.32,0.135,0.55]
const DAMAGE = [0.0,18.0,11.0,42.0]
var target := preload("dummy.gd").new()
var rig := preload("res://assets/characters/pip/pip_rig.tscn").instantiate()
var motion := preload("res://assets/characters/pip/pip_motion.gd").new()
var weapon := Sprite2D.new()
var state := MayhemState.fresh()
var bag := {"training":true,"pos":Vector2(1310,830),"total":0.0,"last_hit":0.0,"flash":0.0}
var slot := 0
var cooldown := 0.0
var elapsed := 0.0
var hits: Array[Vector2] = []
var hold := 0.0
var recoil := 0.0
var evade := 0.0
var evade_cd := 0.0
var just_dodged := false
var direction := Vector2.RIGHT
var shots := 0
var effects := Node2D.new()

func setup_combat() -> void:
	add_child(effects)
	effects.draw.connect(draw_effects)
	player.add_child(rig)
	motion.bind_rig(rig)
	player.add_child(weapon)
	weapon.centered = false
	weapon.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	target.position = bag.pos
	$Actors.add_child(target)
	state.enemies = [bag]
	equip(0)

func equip(index: int) -> void:
	slot = index
	weapon.texture = Gear[index]
	weapon.visible = index != 0
	recoil = 0
	$HUD.slots[index].button_pressed = true

func dodge() -> void:
	if evade_cd <= 0:
		evade = 0.22
		evade_cd = 1.5
		just_dodged = true

func leave() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode in [KEY_1,KEY_2,KEY_3,KEY_4]: equip(event.keycode-KEY_1)
		if event.keycode == KEY_SPACE: dodge()
		if event.keycode == KEY_ESCAPE: leave()

func obstruction(from: Vector2,to: Vector2) -> bool:
	var query := PhysicsRayQueryParameters2D.create(from,to,1)
	return not get_world_2d().direct_space_state.intersect_ray(query).is_empty()

func _physics_process(dt: float) -> void:
	step(dt,controls.movement(),controls.aim(player.get_global_transform_with_canvas().origin-Vector2(0,24)))

func step(dt: float, movement: Vector2, aim: Vector2) -> void:
	elapsed += dt
	hold = maxf(0,hold-dt)
	if hold>0: return
	evade = maxf(0,evade-dt)
	evade_cd = maxf(0,evade_cd-dt)
	cooldown = maxf(0,cooldown-dt)
	recoil = maxf(0,recoil-dt)
	player.velocity = player.velocity.move_toward(movement.limit_length()*185*(2.7 if evade>0 else 1.0),dt*1450)
	player.move_and_slide()
	var aiming := aim.length()>0.14
	if aiming: direction = aim.normalized()
	elif movement.length()>0.05: direction = movement.normalized()
	var fired := aiming and slot>0 and cooldown<=0
	if fired:
		cooldown = DELAYS[slot]
		recoil = cooldown
		shots += 1
		if slot==3:
			var to: Vector2 = bag.pos-player.position
			if to.length()<75 and direction.dot(to.normalized())>0.4 and not obstruction(player.position,bag.pos):
				CombatSystem.hit_enemy(state,bag,DAMAGE[slot],"player")
		else:
			CombatSystem.projectile(state,player.position,direction,DAMAGE[slot],"player")
	CombatSystem.tick(state,dt,obstruction)
	if bag.total>0 and bag.flash>0:
		hits.append(Vector2(elapsed,bag.last_hit))
		target.number = 0.6
		target.flash = 0.18
		target.last_damage = bag.last_hit
		target.impact = direction
		hold = 0.035 if slot==3 else 0.017
		bag.flash = 0.0
	while not hits.is_empty() and elapsed-hits[0].x>3: hits.pop_front()
	var sum := 0.0
	for hit in hits: sum += hit.y
	$HUD.stats.text = "  Eğitim Kuklası   ·   Toplam %d   ·   DPS %.1f  " % [bag.total,sum/3.0]
	target.number = maxf(0,target.number-dt)
	target.flash = maxf(0,target.flash-dt)
	target.queue_redraw()
	motion.advance(dt,player.get_real_velocity(),direction,fired,just_dodged,false,false,slot!=3)
	just_dodged = false
	var pulse := recoil/maxf(0.01,DELAYS[slot])
	preload("weapon_grip.gd").pose(motion,weapon,slot,direction,pulse)
	player.move_child(weapon,0 if direction.y < -0.35 else -1)
	effects.queue_redraw()

func draw_effects() -> void:
	for shot in state.projectiles:
		var p: Vector2 = shot.pos-Vector2(0,27)
		effects.draw_line(p-shot.dir*12,p,Color("#ffe093"),3)
	if slot>0 and recoil>DELAYS[slot]-0.075:
		var tip := weapon.to_global(Vector2(30 if slot==1 else 49,0))
		if slot==3:
			effects.draw_arc(player.position-Vector2(0,26),32,direction.angle()-0.65,direction.angle()+0.75,16,Color("#ffe9b8"),3)
		else:
			effects.draw_line(tip,tip+direction*(10 if slot==2 else 6),Color("#fff0a6"),4)
