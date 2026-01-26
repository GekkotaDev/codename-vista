## 
class_name ResourceModel
extends Resource

var _state: Dictionary[StringName, Variant] = { }

signal diff(changed: Dictionary[String, Variant])


func _init() -> void:
	init_state()
	changed.connect(on_changed)


## Mark the exported variable through its setter as having changed.
func change(key: StringName, value: Variant) -> Variant:
	_state.set(key, value)
	return value


## Connect a callback to the resource model.
func subscribe(callback: Callable, flags: int = 0):
	diff.connect(callback, flags)


## Called to initialize the resource model.
func init_state():
	pass


## Called when the internal state of the resource has been updated.
func on_changed():
	pass


func set_state(setter: Callable):
	var diff_map: Dictionary[StringName, Variant] = { }
	var previous_state := _state.duplicate()

	setter.call()

	for key in _state:
		if _state[key] == previous_state[key]:
			continue
		diff_map[key] = _state[key]

	changed.emit()
	diff.emit(diff_map)
