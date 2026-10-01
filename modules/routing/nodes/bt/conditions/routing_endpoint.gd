@tool
class_name RoutingEndpoint extends ConditionLeaf

@export var control: Control

@export_group("Animations")
@export var entry_animation: ProtonControlAnimation
@export var exit_animation: ProtonControlAnimation

enum Presence {
	PRESENT,
	TRANSITION_IN,
	TRANSITION_OUT,
	ABSENT,
}


func tick(actor: Node, blackboard: Blackboard) -> int:
	var route := blackboard.get_value(&"route")
