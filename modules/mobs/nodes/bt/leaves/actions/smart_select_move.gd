@tool
class_name ActionSmartSelectMove
extends ActionLeaf

var training: MobTraining


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor is BattleParticipant3D:
		return _of(actor)
	return FAILURE


func _of(actor: BattleParticipant3D):
	actor.moves
	# 1. Iterate over all moves and assign a weight
	# 2. Select the one that does the most damage OR contributes most
	return SUCCESS
