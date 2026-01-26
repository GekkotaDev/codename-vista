@tool
class_name VisibilityRouterNode
extends RouterNode

@export_group("Nodes")
@export var view: Control


func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return

	update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if in_transition == null:
		warnings.push_back(
			"No enter transition present.",
		)

	if out_transition == null:
		warnings.push_back(
			"No exit transition present.",
		)

	if view == null:
		warnings.push_back(
			"Router node must have node to present.",
		)

	return warnings


func _ready() -> void:
	var parent := get_parent()
	if parent is RouterNode:
		root = false


func reveal():
	view.visible = true
	in_transition.animation_begun.connect(on_reveal, ConnectFlags.CONNECT_ONE_SHOT)
	in_transition.animation_ended.connect(on_postreveal, ConnectFlags.CONNECT_ONE_SHOT)
	in_transition.start()


##
func goto(destination: String) -> RouterNode:
	if destination not in edges:
		return self

	var router := edges[destination]

	out_transition.animation_begun.connect(on_leave, ConnectFlags.CONNECT_ONE_SHOT)
	out_transition.animation_ended.connect(
		func():
			on_postleave()
			view.visible = false
			router.reveal(),
		ConnectFlags.CONNECT_ONE_SHOT,
	)
	out_transition.start()

	return router
