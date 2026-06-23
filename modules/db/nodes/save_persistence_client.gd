##
@abstract class_name SavePersistenceClient
extends Node

const GROUP_NAME := &"db/persistence_client"


##
@abstract func save(file: SaveFile) -> Error


func _ready() -> void:
	add_to_group(GROUP_NAME)


##
func walk(nodes: Array[Node], walker: Callable):
	return nodes.map(
		func(node: Node):
			walk(node.get_children(), walker)
			walker.call(node)
	)
