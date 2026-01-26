##
@abstract
class_name PersistenceProxy
extends Node

##
@export var resource: PersistedResource

##
@export var target: Array[Node] = []


##
@abstract func walk(node: Node) -> Error


func _walk(nodes: Array[Node] = []):
	if nodes.is_empty():
		var root := get_tree().current_scene.get_children()
		nodes = root if target.is_empty() else target

	for node in nodes:
		if node is PersistenceProxy:
			continue

		_walk(node.get_children())
		var result := walk(node)

		if result != Error.OK:
			return result


##
func save() -> Error:
	return _walk()
