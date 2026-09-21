@tool
class_name ActionSmartSelectMove
extends ActionLeaf

var memory: MobMemory = MobMemory.new()


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor is BattleParticipant3D:
		return _of(actor)
	return FAILURE


func _of(actor: BattleParticipant3D):
	# 1. Iterate over all moves and assign a weight
	# 2. Select the one that does the most damage OR contributes most
	var target := actor.target
	var moves := actor.moves

	for move in moves:
		var training := MobTraining.new()
		var stats := training.train(move, actor.target.stats.duplicate())

	var priority := memory.query_priorities()

	if priority.size() <= 0:
		return FAILURE

	for move in moves:
		if move.name == priority[0]:
			move.inflict_effect()
			return SUCCESS

	return FAILURE
