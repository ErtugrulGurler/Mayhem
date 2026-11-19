class_name TwinStickInput
extends Node
## Owns only pointer IDs inside pad circles. World placement has a separate band.
var movement:=Vector2.ZERO
var aim:=Vector2.ZERO
var owners: Dictionary={}
var centers=[Vector2(90,395),Vector2(870,395)]
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			for side in range(2):
				if event.position.distance_to(centers[side])<76 and not owners.values().has(side):
					owners[event.index]=side
					update_pad(side,event.position)
					get_viewport().set_input_as_handled()
					break
		elif owners.has(event.index):
			update_pad(owners[event.index],centers[owners[event.index]])
			owners.erase(event.index)
			get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag and owners.has(event.index):
		update_pad(owners[event.index],event.position)
		get_viewport().set_input_as_handled()
func update_pad(side: int,at: Vector2) -> void:
	var value: Vector2=((at-centers[side])/58.0).limit_length()
	if value.length()<0.15: value=Vector2.ZERO
	if side==0: movement=value
	else: aim=value
func clear() -> void:
	movement=Vector2.ZERO
	aim=Vector2.ZERO
	owners.clear()
func _notification(what: int) -> void:
	if what==NOTIFICATION_APPLICATION_FOCUS_OUT: clear()
