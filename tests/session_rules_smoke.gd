extends SceneTree
const SessionRules = preload("res://prototype/session_rules.gd")

var failures: Array[String] = []

func check(value: bool, description: String) -> void:
	if not value:
		failures.append(description)

func _initialize() -> void:
	check(SessionRules.can_join(["A", "B", "C", "D"], "A"), "Reserved participant can rejoin")
	check(not SessionRules.can_join(["A", "B", "C", "D"], "E"), "A fifth participant cannot join")
	check(SessionRules.can_join(["A", "B"], "C"), "Unused slot is available")
	check(not SessionRules.can_join([], ""), "Empty identity is rejected")
	var members: Array[String] = ["A", "B", "C", "D"]
	check(SessionRules.reserve_player(members, "E") == members, "Rejected participant cannot reserve slot")
	check(SessionRules.revive_seconds(true) < SessionRules.revive_seconds(false), "Clinic speeds up revival")
	check(not SessionRules.may_count_revive_time(0, false), "No living teammate halts revival timer")
	check(not SessionRules.may_count_revive_time(1, true), "Paused session halts revival timer")
	check(SessionRules.may_count_revive_time(1, false), "Living teammate permits revival timer")
	check(SessionRules.current_age(1) == 0, "First wave first age")
	check(SessionRules.current_age(20) == 0, "Wave 20 still first age")
	check(SessionRules.current_age(21) == 1, "Wave 21 starts second age")
	check(SessionRules.current_age(121) == 5, "Endless waves stay at sixth age")
	check(SessionRules.is_checkpoint_wave(5), "Checkpoint at wave 5")
	check(SessionRules.is_elite_wave(5), "Elite at wave 5")
	check(SessionRules.is_boss_wave(10), "Boss at wave 10")
	check(not SessionRules.is_elite_wave(10), "Boss replaces elite")
	check(SessionRules.retry_attack_seed(17, 10, 1) != SessionRules.retry_attack_seed(17, 10, 2), "Attack variations change on retry")
	for failure in failures:
		push_error("SESSION RULE FAILURE: " + failure)
	print("Session rules: 18 checks, %d failures" % failures.size())
	quit(1 if not failures.is_empty() else 0)
