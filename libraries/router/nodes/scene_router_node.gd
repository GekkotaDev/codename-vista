@tool
class_name SceneRouterNode
extends RouterNode

@export_group("Nodes")
@export var target: Node
@export var scene: PackedScene

var _node: Node


func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return

	update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if target == null:
		warnings.push_back(
			"No target node to instantiate scene in.",
		)

	if in_transition == null:
		warnings.push_back(
			"No enter transition present.",
		)

	if out_transition == null:
		warnings.push_back(
			"No exit transition present.",
		)

	if scene == null:
		warnings.push_back(
			"Router node must have scene to instantiate.",
		)

	return warnings


func _ready() -> void:
	var parent := get_parent()
	if parent is RouterNode:
		root = false

	if root:
		assert(scene, "No scene attached to router node.")
		assert(scene, "No target node to attach scene.")

		_node = scene.instantiate()
		target.add_child(_node)


func reveal():
	assert(scene, "No scene attached to router node.")
	assert(scene, "No target node to attach scene.")

	_node = scene.instantiate()
	target.add_child(_node)

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

			_node.queue_free()
			_node = null

			router.reveal(),
		ConnectFlags.CONNECT_ONE_SHOT,
	)
	out_transition.start()

	return router
