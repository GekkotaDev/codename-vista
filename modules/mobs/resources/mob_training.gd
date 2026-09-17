class_name MobTraining
extends Resource

@export var id: StringName
@export var priority: Dictionary[StringName, float]


func next():
	for move in priority:
		if priority[move] < 0:
			priority[move] += 0.1
		if priority[move] > 0:
			priority[move] -= 0.1
