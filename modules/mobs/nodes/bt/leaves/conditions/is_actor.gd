@tool
class_name IsActorParticipant extends ConditionLeaf


func tick(actor: Node, _blackboard: Blackboard) -> int:
	return SUCCESS if actor is BattleParticipant3D else FAILURE
