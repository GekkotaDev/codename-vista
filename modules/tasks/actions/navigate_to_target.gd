extends BTAction

#? Parameters
@export var bb_navigation_region: BBNode

#? State
var navigation_agent: NavigationAgent3D
var region: NavigationRegion3D


func _setup() -> void:
	navigation_agent = agent.find_child(&"NavigationAgent3D")
	region = bb_navigation_region.get_value(scene_root, blackboard)


func _tick(_delta: float) -> Status:
	var region_rid := region.get_region_rid()
	var target := NavigationServer3D.region_get_random_point(
		region_rid,
		region.navigation_layers,
		true,
	)

	if navigation_agent == null:
		return BT.FAILURE

	return BT.SUCCESS
