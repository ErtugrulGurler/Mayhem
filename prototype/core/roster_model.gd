class_name RosterModel
extends RefCounted
## P1 offline model only. Not authentication, transport or dedicated-server lifecycle.
var members: Dictionary={}
func join(id: String,character: int) -> bool:
	if members.has(id):
		members[id].active=true
		return true
	if id.strip_edges().is_empty() or members.size()>=4 or character<0 or character>=4: return false
	for value in members.values():
		if value.character==character: return false
	members[id]={"character":character,"active":true,"equipment":{},"alive":true,"revive":0.0}
	return true
func leave(id: String) -> void:
	if members.has(id): members[id].active=false
func tick(dt: float,clinic: bool,paused: bool) -> void:
	if paused: return
	var living:=0
	for m in members.values():
		if m.active and m.alive: living+=1
	if living==0: return
	for m in members.values():
		if m.active and not m.alive:
			m.revive+=dt/(30.0 if clinic else 90.0)
			if m.revive>=1:
				m.alive=true
				m.revive=0
