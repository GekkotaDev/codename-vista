@tool
class_name ActionRandomSelectMove
extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor is not BattleParticipant3D:
		return FAILURE

	return SUCCESS


func _of(actor: BattleParticipant3D):
	var move: MobMove = actor.moves.pick_random()
	move.inflict_effect(actor.target.stats)
