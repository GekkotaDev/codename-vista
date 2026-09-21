class_name MobTraining
extends Resource

@export var score: int = 0


func train(move: MobMove, target: MobStats) -> MobStats:
	var clone: MobStats = target.duplicate()

	for _x in range(move.lifespan):
		move.inflict_effect(clone)

	score = target.current_health - clone.current_health
	return clone
