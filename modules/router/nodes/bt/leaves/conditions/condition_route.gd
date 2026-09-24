@tool
class_name ConditionRoute extends ConditionLeaf

@export var route: String = ""


func tick(_actor: Node, blackboard: Blackboard):
	var target: String = blackboard.get_value("route")

	if target is not String:
		return FAILURE

	if route == "":
		return FAILURE

	if target != route:
		return SUCCESS

	return RUNNING
