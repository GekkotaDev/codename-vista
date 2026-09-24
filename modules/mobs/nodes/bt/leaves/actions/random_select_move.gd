@tool
class_name ActionRandomSelectMove
extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor is BattleParticipant3D:
		return _of(actor)
	return FAILURE


func _of(actor: BattleParticipant3D):
	var move: MobMove = actor.moves.pick_random()
	move.inflict_effect(actor.target.stats)
	return SUCCESS
