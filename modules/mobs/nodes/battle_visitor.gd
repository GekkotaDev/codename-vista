class_name BattleVisitor3D
extends Node3D

@export var participants: Array[BattleParticipant3D] = []

var queue: Array[BattleParticipant3D]


func _ready() -> void:
	for child in get_children():
		if child is BattleParticipant3D:
			participants.append(child)
	queue = participants.duplicate()
	sort_queue()


func sort_queue() -> BattleVisitor3D:
	queue.sort_custom(
		func(a: BattleParticipant3D, b: BattleParticipant3D):
			return a.stats.speed.value <= b.stats.speed.value,
	)
	return self


func next() -> BattleParticipant3D:
	var next_participant: BattleParticipant3D = queue.pop_back()
	sort_queue()

	while next_participant.tick():
		pass

	return next_participant
