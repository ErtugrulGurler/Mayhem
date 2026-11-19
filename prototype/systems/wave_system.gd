class_name MayhemWaves
extends RefCounted
const Rules = preload("res://prototype/session_rules.gd")
static func begin(s: Dictionary) -> bool:
	if s.phase!="prepare" or s.lost: return false
	s.phase="warning"
	s.phase_time=5.0
	s.boss_id="boss_%d" % s.wave if Rules.is_boss_wave(s.wave) else ""
	s.boss_phase=int(CombatSystem.rand_value(s)*3)
	return true
static func tick(s: Dictionary,dt: float) -> bool:
	var checkpoint:=false
	if s.phase=="prepare":
		s.phase_time-=dt
		if s.phase_time<=0: begin(s)
	elif s.phase=="warning":
		s.phase_time-=dt
		if s.phase_time<=0:
			s.phase="attack"
			s.spawn_left=3+int(s.wave*0.7)
			s.spawn_clock=0.0
			if Rules.is_boss_wave(s.wave): EnemySystem.spawn(s,"boss",entry(s))
			elif Rules.is_elite_wave(s.wave): EnemySystem.spawn(s,"siege",entry(s))
	elif s.phase=="attack":
		s.spawn_clock-=dt
		if s.spawn_left>0 and s.spawn_clock<=0:
			var kind: String=["normal","runner","saboteur","siege"][s.spawn_left%4]
			EnemySystem.spawn(s,kind,entry(s))
			s.spawn_left-=1
			s.spawn_clock=1.5
		var count:=0
		for e in s.enemies:
			if e.main: count+=1
		if s.spawn_left==0 and count==0:
			checkpoint=Rules.is_checkpoint_wave(s.wave)
			s.wave+=1
			s.stats.peak_wave=maxi(s.stats.peak_wave,s.wave)
			s.phase="prepare"
			s.phase_time=30.0
	s.raid_clock-=dt
	if s.raid_clock<=0:
		EnemySystem.spawn(s,"runner",entry(s),false)
		s.raid_clock=70.0
	return checkpoint
static func entry(s: Dictionary) -> Vector2:
	var choice:=int(CombatSystem.rand_value(s)*4)
	return [Vector2(90,570),Vector2(1700,600),Vector2(600,70),Vector2(1180,1110)][choice]
