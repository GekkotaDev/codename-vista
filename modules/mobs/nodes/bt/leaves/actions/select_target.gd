@tool
class_name ActionSelectTarget
extends ActionLeaf

@export var groups: Array[StringName]


func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor is BattleParticipant3D:
		return _of(actor)
	return FAILURE


func _intersect_groups(nodes: Array[Node], groups: PackedStringArray) -> Array[BattleParticipant3D]:
	var filtered: Array[BattleParticipant3D] = []

	for node in nodes:
		var skip := false
		for group in groups:
			if not node.is_in_group(group):
				skip = true
			if skip:
				break
		if skip:
			continue
		if node is not BattleParticipant3D:
			continue
		filtered.append(node)

	return filtered


func _of(actor: BattleParticipant3D):
	var other_groups: Array[StringName] = groups.duplicate()
	var first_group: StringName = other_groups.pop_front()
	var targets := _intersect_groups(get_tree().get_nodes_in_group(first_group), other_groups)
	actor.target = targets.pick_random()
	return SUCCESS
