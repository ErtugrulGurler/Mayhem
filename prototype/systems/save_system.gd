class_name MayhemSave
extends RefCounted
## Variant bytes preserve Vector2 and 64-bit RNG state exactly. No objects permitted.
static func write(path: String,state: Dictionary) -> bool:
	var payload:=var_to_bytes(state)
	var file:=FileAccess.open(path+".tmp",FileAccess.WRITE)
	if file==null: return false
	file.store_line("MAYHEM1")
	file.store_line(payload.hex_encode().sha256_text())
	file.store_buffer(payload)
	file.close()
	return DirAccess.rename_absolute(path+".tmp",path)==OK
static func read(path: String) -> Dictionary:
	if not FileAccess.file_exists(path): return {}
	var file:=FileAccess.open(path,FileAccess.READ)
	if file==null or file.get_line()!="MAYHEM1": return {}
	var checksum:=file.get_line()
	var payload:=file.get_buffer(file.get_length()-file.get_position())
	if checksum!=payload.hex_encode().sha256_text(): return {}
	var state=bytes_to_var(payload)
	if not state is Dictionary or state.get("version")!=1 or not state.has_all(["player","structures","stats","core","wave","phase","rng_state"]): return {}
	return state
static func retry(snapshot: Dictionary,previous: Dictionary) -> Dictionary:
	var state: Dictionary=snapshot.duplicate(true)
	state.stats=SessionStatistics.retry(previous.stats,state.stats)
	state.attack_seed=preload("res://prototype/session_rules.gd").retry_attack_seed(state.world_seed,state.wave,state.stats.attempt)
	state.rng_state=0
	state.lost=false
	state.unranked=previous.unranked or state.unranked
	return state
