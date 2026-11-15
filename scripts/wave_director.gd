class_name WaveDirector
extends Node
signal spawn_requested(kind: String, wave: int)
signal changed
var wave := 0
var remaining := 0
var interval := 0.0
var active := false
var spawned := 0

func start_wave() -> void:
	if active:
		return
	wave += 1
	remaining = 6 + wave * 2
	spawned = 0
	interval = 0.0
	active = true
	changed.emit()

func _process(delta: float) -> void:
	if not active:
		return
	interval -= delta
	if remaining > 0 and interval <= 0:
		var kind := "normal"
		if wave >= 2 and spawned % 3 == 1:
			kind = "runner"
		if wave >= 3 and spawned % 5 == 4:
			kind = "tank"
		spawn_requested.emit(kind, wave)
		spawned += 1
		remaining -= 1
		interval = maxf(0.32, 0.95 - wave * 0.035)
	if remaining == 0 and get_tree().get_nodes_in_group("enemies").is_empty():
		active = false
		changed.emit()
