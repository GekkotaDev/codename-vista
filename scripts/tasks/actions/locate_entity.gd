## 
extends BTAction

##
@export var bb_detection_area: BBNode

##
@export var bb_detection_groups: BBStringArray

## 
@export var bb_target: BBVector3

var detection_area: Area3D
var detection_groups: PackedStringArray

var state: Status


func on_body_entered(node: Node3D):
	for group in detection_groups:
		if not node.is_in_group(group):
			continue

		state = SUCCESS
		bb_target.saved_value = node.global_position

		return
	state = FAILURE


func _setup() -> void:
	detection_area = bb_detection_area.get_value(scene_root, blackboard)
	detection_groups = bb_detection_groups.get_value(scene_root, blackboard)

	detection_area.body_entered.connect(on_body_entered)


func _tick(_delta: float) -> Status:
	return state
