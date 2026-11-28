class_name MayhemCatalog
extends RefCounted
## All numbers here are prototype balance assumptions, not final user decisions.
const SIZE = Vector2(1800, 1200)
const REACH = 95.0
## The original Guard profile keeps its index in checkpoints and suspended games.
const PIP_PROFILE := 0
const CHARACTERS = [
	{"name":"Ada / Muhafız", "color":"#ffc66b", "hp":120.0, "speed":185.0, "melee":42.0, "skill":"shockwave"},
	{"name":"Bora / İzci", "color":"#83d9a2", "hp":90.0, "speed":215.0, "melee":34.0, "skill":"sprint"},
	{"name":"Cem / Usta", "color":"#9fc9fa", "hp":105.0, "speed":190.0, "melee":39.0, "skill":"brace"},
	{"name":"Duru / Sıhhiyeci", "color":"#eea6d0", "hp":100.0, "speed":195.0, "melee":36.0, "skill":"bandage"}
]
const AGES = ["Taş","Tunç / Demir","Orta Çağ","Sanayi","Modern","İleri / Kıyamet"]
const LABELS = {"wood":"odun","stone":"taş","ore":"cevher","metal":"metal","ammo":"mermi","parts":"parça","medkit":"ilk yardım","bow":"yay","scatter":"saçmalı","heavy":"kütük","rare":"nadir"}
const BUILDINGS = {
	"wall":{"name":"Duvar","cost":{"wood":3,"stone":2},"hp":170.0,"time":3.0,"wave":1,"color":"#b4ae97"},
	"depot":{"name":"Depo","cost":{"wood":5},"hp":140.0,"time":4.0,"wave":1,"color":"#d9ad70"},
	"smelter":{"name":"İzabe","cost":{"stone":4,"wood":2},"hp":130.0,"time":4.0,"wave":1,"color":"#eb9e73"},
	"ammo_bench":{"name":"Mühimmat","cost":{"wood":4,"stone":2},"hp":110.0,"time":4.0,"wave":1,"color":"#dcd172"},
	"turret":{"name":"Kule","cost":{"wood":6,"stone":3},"hp":145.0,"time":5.0,"wave":1,"color":"#8bafcb"},
	"trap":{"name":"Tuzak","cost":{"wood":2,"stone":1},"hp":70.0,"time":2.0,"wave":1,"color":"#d4ad91"},
	"clinic":{"name":"Klinik","cost":{"wood":6,"stone":4},"hp":120.0,"time":5.0,"wave":1,"color":"#eb9eb9"},
	"medbench":{"name":"Medkit tezgâhı","cost":{"wood":4,"stone":3},"hp":100.0,"time":4.0,"wave":1,"color":"#95d4b0"},
	"workshop":{"name":"Parça atölyesi","cost":{"wood":5,"stone":3},"hp":130.0,"time":4.0,"wave":1,"color":"#bda7dc"},
	"bowbench":{"name":"Yay tezgâhı","cost":{"wood":3,"stone":2},"hp":100.0,"time":3.0,"wave":1,"color":"#dbbb78"},
	"scatterbench":{"name":"Saçmalı tezgâhı","cost":{"wood":4,"stone":4},"hp":100.0,"time":4.0,"wave":1,"color":"#cbb1a0"},
	"conveyor":{"name":"Konveyör","cost":{"wood":3,"metal":2},"hp":90.0,"time":3.0,"wave":11,"color":"#7fb9b1"},
	"generator":{"name":"Jeneratör","cost":{"stone":4,"metal":4},"hp":160.0,"time":5.0,"wave":61,"color":"#e3c16a"},
	"cable":{"name":"Kablo","cost":{"metal":1},"hp":60.0,"time":2.0,"wave":61,"color":"#d5d571"},
	"electric_bench":{"name":"Elektrikli mühimmat","cost":{"metal":4,"stone":3},"hp":130.0,"time":4.0,"wave":61,"color":"#9ed5df"}
}
const RECIPES = {
	"smelter":{"input":{"ore":2,"wood":1},"output":{"metal":2},"time":3.0},
	"ammo_bench":{"input":{"metal":1,"wood":1},"output":{"ammo":8},"time":2.5},
	"medbench":{"input":{"wood":2,"stone":1},"output":{"medkit":1},"time":4.0},
	"workshop":{"input":{"metal":1,"wood":1},"output":{"parts":1},"time":4.0},
	"bowbench":{"input":{"wood":3,"stone":1},"output":{"bow":1},"time":4.0},
	"scatterbench":{"input":{"metal":2,"wood":2},"output":{"scatter":1},"time":5.0},
	"electric_bench":{"input":{"metal":1},"output":{"ammo":12},"time":2.0}
}
static func resource_text(items: Dictionary) -> String:
	var parts: PackedStringArray = []
	for key in items:
		parts.append("%s:%d" % [LABELS.get(key,key),items[key]])
	return " ".join(parts) if not parts.is_empty() else "boş"
static func building(kind: String, at: Vector2, id: int) -> Dictionary:
	var data: Dictionary = BUILDINGS[kind]
	return {"id":id,"kind":kind,"pos":at,"hp":data.hp,"max_hp":data.hp,"delivered":{},"progress":0.0,"built":false,
		"input":{},"output":{},"stock":{},"work":0.0,"cooldown":0.0,"level":1,"enabled":true,"powered":false,"links":[],"flow":0.0}
