extends RefCounted
## Mayhem prototype: session rules only. Network authorization is NOT implemented here.
## Source: docs/DESIGN_V0_4.md; docs/REQUIREMENTS_V0_1.md.

const MAX_PLAYERS: int = 4
const REVIVE_WITHOUT_CLINIC: float = 90.0 # Prototype balance assumption
const REVIVE_WITH_CLINIC: float = 30.0 # Prototype balance assumption

static func can_join(reserved_ids: Array[String], player_id: String) -> bool:
	if player_id.strip_edges().is_empty():
		return false
	if reserved_ids.has(player_id):
		return true
	return reserved_ids.size() < MAX_PLAYERS

static func reserve_player(reserved_ids: Array[String], player_id: String) -> Array[String]:
	var updated: Array[String] = reserved_ids.duplicate()
	if can_join(updated, player_id) and not updated.has(player_id):
		updated.append(player_id)
	return updated

static func revive_seconds(clinic_operational: bool) -> float:
	return REVIVE_WITH_CLINIC if clinic_operational else REVIVE_WITHOUT_CLINIC

static func may_count_revive_time(living_teammates: int, session_paused: bool) -> bool:
	return living_teammates > 0 and not session_paused

static func current_age(wave: int) -> int:
	# Six technology ages; last age persists during endless waves.
	return mini(5, maxi(0, int(floor(float(wave - 1) / 20.0))))

static func is_boss_wave(wave: int) -> bool:
	return wave > 0 and wave % 10 == 0

static func is_elite_wave(wave: int) -> bool:
	return wave > 0 and wave % 5 == 0 and not is_boss_wave(wave)

static func is_checkpoint_wave(wave: int) -> bool:
	return wave > 0 and wave % 5 == 0

static func retry_attack_seed(world_seed: int, wave: int, retry_number: int) -> int:
	# Keep world identity while varying attack-specific RNG upon checkpoint retry.
	# For suspend/resume, restore the stored attack RNG state instead.
	return posmod(world_seed * 1103515245 + wave * 12345 + retry_number * 10007, 2147483647)
