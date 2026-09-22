@tool
extends ActionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor is BattleParticipant3D:
		return _of(actor)
	return FAILURE


func _of(actor: BattleParticipant3D):
	actor.tree.disable()
	return SUCCESS
