class_name GameData
extends RefCounted
## Central balancing data; simulation does not depend on artwork.
const TOWERS = {
	"archer": {"title": "Okçu", "cost": 70, "damage": 15.0, "range": 150.0, "cooldown": 0.65, "speed": 440.0, "splash": 0.0, "color": Color("#ffd36b")},
	"mage": {"title": "Büyücü", "cost": 100, "damage": 34.0, "range": 135.0, "cooldown": 1.15, "speed": 310.0, "splash": 0.0, "color": Color("#ac83ff")},
	"cannon": {"title": "Topçu", "cost": 125, "damage": 27.0, "range": 145.0, "cooldown": 1.65, "speed": 250.0, "splash": 65.0, "color": Color("#ff9964")}
}
const ENEMIES = {
	"normal": {"health": 48.0, "speed": 49.0, "reward": 12, "color": Color("#f39366"), "radius": 12.0},
	"runner": {"health": 29.0, "speed": 86.0, "reward": 10, "color": Color("#e9cc64"), "radius": 10.0},
	"tank": {"health": 155.0, "speed": 30.0, "reward": 24, "color": Color("#a596d3"), "radius": 17.0}
}
const PATH = [
	Vector2(-35, 198), Vector2(145, 198), Vector2(235, 305),
	Vector2(370, 305), Vector2(453, 165), Vector2(600, 165),
	Vector2(681, 328), Vector2(815, 328), Vector2(995, 225)
]
const SITES = [
	Vector2(116, 130), Vector2(178, 286), Vector2(306, 230),
	Vector2(345, 380), Vector2(490, 245), Vector2(578, 97),
	Vector2(613, 325), Vector2(748, 250), Vector2(835, 400)
]
static func upgrade_cost(kind: String, level: int) -> int:
	return int(TOWERS[kind].cost * (0.7 + level * 0.45))
