class_name MobMemory
extends Resource

@export var id: StringName
@export var priority: Dictionary[StringName, float]


func query_priorities() -> PackedStringArray:
	var move_names: Array[StringName] = priority.keys()
	move_names.sort_custom(
		func(a: StringName, b: StringName):
			return priority[a] > priority[b],
	)

	return move_names
