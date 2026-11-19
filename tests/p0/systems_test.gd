extends SceneTree
var checks:=0
var failures:=0
func check(ok: bool,text: String) -> void:
	checks+=1
	if ok: print("PASS ",text)
	else:
		failures+=1
		push_error("FAIL "+text)
func fixture(s: Dictionary,kind: String,at: Vector2) -> Dictionary:
	var b:=MayhemCatalog.building(kind,at,MayhemState.next_id(s))
	b.built=true
	s.structures.append(b)
	return b
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var s:=MayhemState.fresh()
	check(s.structures.is_empty() and s.player.inventory.is_empty() and s.player.weapons==["",""],"SYS-002 zero free equipment or buildings")
	check(MayhemCatalog.CHARACTERS.size()==4,"SYS-010 four distinct profiles")
	for i in range(4):
		var c:=MayhemState.fresh(i)
		c.player.pos=c.sources[0].pos
		check(PlayerSystem.gather(c),"CBT-004 character %d can gather without tools" % i)
	var stock: Dictionary={}
	check(PhysicalInventory.add(stock,"wood",40,30)==30,"RES-006 inventory capacity")
	check(not PhysicalInventory.remove(stock,{"wood":31}) and stock.wood==30,"RES-005 failed spend atomic")
	var target: Dictionary={}
	check(PhysicalInventory.transfer(stock,target,"wood",10,5)==5 and stock.wood==25,"RES-005 local transfer honors capacity")
	var placement: Vector2=s.core.pos+Vector2(160,40)
	check(not BuildingSystem.can_place(s,"wall",s.player.pos),"BLD-009 player occupied area rejected")
	check(not BuildingSystem.can_place(s,"wall",Vector2(900,200)),"MAP-004 river placement rejected")
	var e:=EnemySystem.spawn(s,"normal",placement)
	check(not BuildingSystem.can_place(s,"wall",placement),"BLD-009 enemy occupied area rejected")
	s.enemies.clear()
	var b:=BuildingSystem.place(s,"wall",placement)
	check(not b.is_empty(),"BLD-001 free placement away from core")
	if b.is_empty(): quit(1); return
	s.player.inventory={"wood":3,"stone":2}
	BuildingSystem.tick(s,20)
	check(not b.built,"BLD-003 global inventory does not auto build")
	s.player.pos=Vector2(60,60)
	check(BuildingSystem.deliver(s,b)==0 and s.player.inventory.wood==3,"BLD-003 distant delivery rejected without consuming")
	s.player.pos=b.pos+Vector2(0,65)
	check(BuildingSystem.deliver(s,b)==5 and s.player.inventory.is_empty(),"BLD-003 material arrives physically")
	s.player.pos=Vector2(60,60)
	BuildingSystem.tick(s,3.1)
	check(b.built,"BLD-004 build completes after leaving")
	var snap:=BuildingSystem.snap(s,b.pos+Vector2(6,80))
	check(snap.x==b.pos.x,"BLD-002 near structure alignment")
	s.player.pos=b.pos+Vector2(0,65)
	BuildingSystem.damage(s,b,60)
	s.player.inventory={"wood":2}
	check(BuildingSystem.repair(s,b) and b.hp==140,"BLD-007 repair consumes local resource")
	check(not BuildingSystem.repair(s,b),"BLD-007 repair respects time cooldown")
	BuildingSystem.dismantle(s,b)
	check(s.structures.is_empty() and not s.loot.is_empty(),"BLD-006 dismantle creates physical partial refund")
	var site:=BuildingSystem.place(s,"depot",Vector2(400,300))
	BuildingSystem.damage(s,site,1000)
	check(not s.structures.has(site),"BLD-005 unfinished building destructible")
	var depot:=fixture(s,"depot",Vector2(400,300))
	PhysicalInventory.add(depot.stock,"ore",100,60)
	check(PhysicalInventory.total(depot.stock)==60,"RES-007 depot capacity")
	BuildingSystem.damage(s,depot,1000)
	var spilled:=0
	for loot in s.loot:
		if loot.kind=="ore": spilled+=loot.amount
	check(spilled==30,"RES-008 destroyed depot spills half physical stock")
	var machine:=fixture(s,"smelter",Vector2(450,300))
	ProductionSystem.tick(s,10)
	check(machine.output.is_empty(),"PRD-003 input starvation")
	machine.input={"ore":4,"wood":2}
	machine.output={"metal":24}
	ProductionSystem.tick(s,10)
	check(machine.input.ore==4,"PRD-003 full output stops consumption")
	machine.output.clear()
	machine.hp=machine.max_hp/2
	ProductionSystem.tick(s,2)
	check(machine.output.is_empty() and machine.work==1,"PRD-004 damaged machine slows")
	machine.hp=machine.max_hp
	ProductionSystem.tick(s,2)
	check(machine.output.metal==2,"PRD-001 ore to intermediate metal")
	var parallel:=fixture(s,"smelter",Vector2(550,300))
	parallel.input={"ore":2,"wood":1}
	ProductionSystem.tick(s,3)
	check(parallel.output.metal==2 and machine.output.metal==4,"PRD-005 parallel production")
	s.player.pos=machine.pos+Vector2(0,60)
	s.player.inventory={"metal":2,"wood":2}
	check(ProductionSystem.upgrade(s,machine) and machine.level==2,"PRD-005 physical machine upgrade")
	var core_test:=MayhemState.fresh()
	core_test.core.hp=8
	var attacker:=EnemySystem.spawn(core_test,"normal",core_test.core.pos+Vector2(0,-30))
	EnemySystem.strike(core_test,attacker,core_test.core)
	check(core_test.lost and core_test.core.hp==0,"SYS-004 core zero HP defeats session")
	for boundary in [[1,0],[20,0],[21,1],[40,1],[41,2],[60,2],[61,3],[80,3],[81,4],[100,4],[101,5],[121,5]]:
		check(preload("res://prototype/session_rules.gd").current_age(boundary[0])==boundary[1],"SYS-009 age threshold "+str(boundary[0]))
	for location in range(2):
		for variation in range(2):
			var map_state:=MayhemState.fresh(0,location,variation)
			var reachable:=true
			for source in map_state.sources:
				if MayhemTerrain.path(map_state.core.pos,source.pos,[],false).is_empty(): reachable=false
			check(reachable,"MAP-002 source reachability location %d variation %d" % [location,variation])
	test_player_resources()
	test_power()
	test_logistics()
	test_combat()
	test_navigation()
	test_save()
	test_roster()
	print("SYSTEMS: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
func test_power() -> void:
	var s:=MayhemState.fresh()
	s.wave=61
	var gen:=fixture(s,"generator",Vector2(300,300))
	var wire:=fixture(s,"cable",Vector2(360,300))
	var load_a:=fixture(s,"electric_bench",Vector2(430,300))
	wire.links=[gen.id,load_a.id]
	var gen_b:=fixture(s,"generator",Vector2(1100,600))
	var wire_b:=fixture(s,"cable",Vector2(1160,600))
	var load_b:=fixture(s,"electric_bench",Vector2(1230,600))
	wire_b.links=[gen_b.id,load_b.id]
	PowerGraph.tick(s)
	check(load_a.powered and load_b.powered,"PWR-002 two physical networks powered")
	wire.enabled=false
	PowerGraph.tick(s)
	check(not load_a.powered and load_b.powered,"PWR-003 cut only affects connected network")
	load_a.input={"metal":1}
	ProductionSystem.tick(s,5)
	check(load_a.output.is_empty(),"PWR-003 disconnected production halts immediately")
	wire.enabled=true
	var overload:=fixture(s,"electric_bench",Vector2(430,370))
	var wire_c:=fixture(s,"cable",Vector2(360,370))
	wire_c.links=[gen.id,overload.id]
	PowerGraph.tick(s)
	check(not load_a.powered and not overload.powered and load_b.powered,"PWR-004 overload shuts down whole affected network")
	overload.enabled=false
	PowerGraph.tick(s)
	ProductionSystem.tick(s,2)
	check(load_a.powered and load_a.output.ammo==12,"PWR-004 reducing load restores production")
func test_logistics() -> void:
	var s:=MayhemState.fresh()
	var source:=fixture(s,"ammo_bench",Vector2(400,500))
	var sink:=fixture(s,"turret",Vector2(560,500))
	var belt:=fixture(s,"conveyor",Vector2(480,500))
	belt.links=[source.id,sink.id]
	source.output={"ammo":2}
	LogisticsSystem.tick(s,1)
	check(s.packets.is_empty() and source.output.ammo==2,"PRD-006 no automation before 11")
	s.wave=11
	LogisticsSystem.tick(s,0.1)
	check(s.packets.size()==1 and source.output.ammo==1 and sink.input.is_empty(),"PRD-006 physical in-flight packet")
	source.output.clear()
	LogisticsSystem.tick(s,2)
	check(sink.input.ammo==1 and s.packets.is_empty(),"PRD-006 packet arrives in destination buffer")
	source.output={"ammo":1}
	LogisticsSystem.tick(s,0.7)
	s.structures.erase(belt)
	LogisticsSystem.tick(s,0.1)
	check(s.loot.size()==1,"RES-005 severed conveyor preserves in-flight loot")
func test_combat() -> void:
	var s:=MayhemState.fresh()
	s.player.slot=0
	s.player.weapons[0]="bow"
	check(not PlayerSystem.reload_weapon(s),"CBT-006 cannot reload without physical ammo")
	s.player.inventory={"ammo":8}
	check(PlayerSystem.reload_weapon(s) and s.player.magazines[0]==6 and s.player.inventory.ammo==2,"CBT-006 magazine plus reserve")
	CombatSystem.attack(s,Vector2.RIGHT)
	check(s.projectiles.size()==1 and s.player.magazines[0]==5 and s.projectiles[0].dir==Vector2.RIGHT,"CBT-001 exact aim direction, ammo consumed")
	s.projectiles.clear()
	s.player.shot_cd=0
	s.player.slot=-1
	var enemy:=EnemySystem.spawn(s,"normal",s.player.pos+Vector2(45,0))
	CombatSystem.attack(s,Vector2.RIGHT)
	check(not s.enemies.has(enemy) and s.stats.player.damage>0 and s.stats.team.damage==0,"CBT-015 strong melee no ammo, player attribution")
	var turret:=fixture(s,"turret",Vector2(400,400))
	enemy=EnemySystem.spawn(s,"normal",Vector2(500,400))
	CombatSystem.tick(s,0.1)
	check(s.projectiles.is_empty(),"PRD-011 empty turret cannot shoot")
	turret.input={"ammo":2}
	CombatSystem.tick(s,0.1)
	check(not s.projectiles.is_empty(),"PRD-011 loaded turret auto fire")
	for i in range(40): CombatSystem.tick(s,0.025)
	check(s.stats.team.damage>0 and s.stats.player.damage==41,"STA-002 team damage separate from direct player")
	CombatSystem.skill(s)
	check(s.player.skill_cd>0,"CBT-002 distinct cooldown skill")
	CombatSystem.dodge(s,Vector2.RIGHT)
	check(s.player.dodge_time>0,"CBT-009 independent dodge")
	s.player.dodge_time=0
	PlayerSystem.damage(s,999)
	var at: Vector2=s.player.pos
	PlayerSystem.tick(s,1,Vector2.RIGHT)
	check(s.player.down and s.player.pos.distance_to(at)<70,"CBT-012 downed crawl")
	PlayerSystem.tick(s,12,Vector2.ZERO)
	check(s.lost,"SAV-003 solo bleedout defeat")
func test_navigation() -> void:
	var s:=MayhemState.fresh()
	for source in s.sources:
		check(not MayhemTerrain.path(s.core.pos,source.pos,[],false).is_empty(),"MAP-002 required source route "+source.kind)
	check(not MayhemTerrain.path(Vector2(700,200),Vector2(1100,200),[],false).is_empty(),"MAP-004 navigation crosses bridge around river")
	var b:=fixture(s,"wall",Vector2(500,600))
	var enemy:=EnemySystem.spawn(s,"siege",Vector2(450,600))
	for i in range(40): EnemySystem.tick(s,0.05)
	check(b.hp<b.max_hp,"ENM-002 siege breaks obstructing wall")
	var producer:=fixture(s,"smelter",Vector2(1300,600))
	enemy=EnemySystem.spawn(s,"saboteur",Vector2(300,600))
	check(EnemySystem.target(s,enemy)==s.core,"ENM-003 unseen distant production ignored")
	enemy.pos=Vector2(1200,600)
	check(EnemySystem.target(s,enemy)==producer,"ENM-003 visible production targeted")
func test_save() -> void:
	var s:=MayhemState.fresh(2,1,1)
	var b:=fixture(s,"smelter",Vector2(1100,800))
	b.input={"ore":7,"wood":2}
	b.hp=80
	CombatSystem.rand_value(s)
	check(MayhemSave.write("user://p0_test.bin",s),"SAV-002 atomic snapshot write")
	var restored:=MayhemSave.read("user://p0_test.bin")
	check(var_to_bytes(s)==var_to_bytes(restored),"SAV-002 full state roundtrip exact including RNG")
	check(CombatSystem.rand_value(s)==CombatSystem.rand_value(restored),"SAV-002 next RNG value exact on resume")
	s.stats.seconds=90
	s.stats.player.damage=100
	s.wave=10
	s.boss_id="boss_10"
	restored=s.duplicate(true)
	var retry:=MayhemSave.retry(restored,s)
	check(retry.boss_id==s.boss_id and retry.world_seed==s.world_seed and retry.attack_seed!=s.attack_seed,"ENM-005 retry keeps world/boss, changes attack sub-seed")
	check(retry.stats.seconds==90 and retry.stats.attempt==1 and retry.stats.history[0].player.damage==100,"STA-003 time and attempt history preserved")
	var file:=FileAccess.open("user://p0_test.bin",FileAccess.WRITE)
	file.store_string("broken")
	file.close()
	check(MayhemSave.read("user://p0_test.bin").is_empty(),"SAV-002 corrupt save rejected")
	DirAccess.remove_absolute("user://p0_test.bin")
func test_roster() -> void:
	var model:=RosterModel.new()
	for i in range(4): check(model.join(str(i),i),"P1 MODEL roster slot "+str(i))
	model.members["0"].equipment={"bow":1}
	model.leave("0")
	check(not model.join("5",0),"P1 MODEL fifth identity rejected after disconnect")
	check(model.join("0",3) and model.members["0"].character==0 and model.members["0"].equipment.bow==1,"P1 MODEL rejoin restores reserved character and gear")
	model.members["0"].alive=false
	model.tick(15,false,false)
	var progress: float=model.members["0"].revive
	model.tick(15,true,true)
	check(model.members["0"].revive==progress,"P1 MODEL revive paused with session")
	model.tick(15,true,false)
	check(model.members["0"].revive>progress+0.4,"P1 MODEL clinic speeds timed revival")

func test_player_resources() -> void:
	var s:=MayhemState.fresh()
	s.player.pos=s.sources[0].pos
	check(PlayerSystem.gather(s) and not PlayerSystem.gather(s),"RES-002 renewable source rate limited")
	PlayerSystem.tick(s,0.8,Vector2.ZERO)
	check(PlayerSystem.gather(s) and s.sources[0].left==-1,"RES-002 basic source remains renewable")
	s.player.inventory.clear()
	s.player.pos=s.sources[3].pos
	s.sources[3].left=1
	check(PlayerSystem.gather(s) and s.sources[3].left==0 and s.player.inventory.rare==1,"RES-003 finite rare source cannot become renewable")
	s.player.pos=Vector2(300,400)
	var start: Vector2=s.player.pos
	PlayerSystem.tick(s,0.1,Vector2.RIGHT)
	var normal: float=s.player.pos.distance_to(start)
	s.player.pos=start
	s.player.heavy=true
	PlayerSystem.tick(s,0.1,Vector2.RIGHT)
	check(s.player.pos.distance_to(start)<normal*0.6,"RES-006 heavy carrying slows player")
	PlayerSystem.drop(s)
	check(not s.player.heavy and s.loot[-1].kind=="heavy","RES-006 heavy load physically dropped")
	var clinic:=fixture(s,"clinic",s.player.pos+Vector2(0,65))
	s.player.inventory={"wood":1,"medkit":1}
	s.player.hp=20
	check(PlayerSystem.clinic(s,clinic) and s.player.hp==55,"CBT-014 separate built clinic healing")
	check(PlayerSystem.heal(s) and s.player.hp==105 and not s.player.inventory.has("medkit"),"CBT-014 medkit physically consumed")
	s.player.hp=25
	s.loot.append({"pos":s.player.pos,"kind":"heal","amount":1})
	s.loot.append({"pos":s.player.pos,"kind":"ore","amount":2})
	PlayerSystem.tick(s,0.1,Vector2.ZERO)
	check(s.player.hp==50 and s.player.inventory.get("ore",0)==0,"CBT-010 heal auto, resource requires interaction")
	s.player.inventory={"bow":1,"scatter":1,"parts":1}
	check(PlayerSystem.equip(s) and s.player.weapons[0]=="bow","CBT-005 equip produced ranged weapon")
	s.player.slot=1
	check(PlayerSystem.equip(s) and s.player.weapons[1]=="scatter","CBT-005 two independent changeable weapon slots")
	check(not PlayerSystem.modify(s,clinic),"CBT-007 modification rejected outside workshop")
	var shop:=fixture(s,"workshop",s.player.pos+Vector2(0,-65))
	check(PlayerSystem.modify(s,shop) and s.player.weapon_level==2,"CBT-007 physical parts installed only at workshop")
	s.player.hp=0
	s.player.down=true
	clinic.hp=clinic.max_hp/2
	check(not PlayerSystem.clinic(s,clinic),"CBT-014 damaged clinic cannot rescue")
