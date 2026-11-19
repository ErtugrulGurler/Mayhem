class_name SessionStatistics
extends RefCounted
static func fresh() -> Dictionary:
	return {"seconds":0.0,"peak_wave":1,"attempt":0,"history":[],"player":{"damage":0.0,"kills":0,"gathered":0,"repair":0,"production":0},
		"team":{"damage":0.0,"kills":0,"production":0}}
static func hit(stats: Dictionary, source: String, damage: float, killed: bool) -> void:
	var bucket: Dictionary = stats.player if source == "player" else stats.team
	bucket.damage += damage
	if killed:
		bucket.kills += 1
static func retry(previous: Dictionary, restored: Dictionary) -> Dictionary:
	var result: Dictionary = restored.duplicate(true)
	result.seconds = previous.seconds
	result.peak_wave = maxi(previous.peak_wave, restored.peak_wave)
	result.history = previous.history.duplicate(true)
	result.history.append({"attempt":previous.attempt,"player":previous.player.duplicate(true),"team":previous.team.duplicate(true)})
	result.attempt = previous.attempt+1
	result.player = fresh().player
	result.team = fresh().team
	return result
