@abstract class_name SavePersistenceClient
extends Node

@abstract func save(file: SaveFile) -> Error


func walk(nodes: Array[Node], walker: Callable):
	return nodes.map(
		func(node: Node):
			walk(node.get_children(), walker)
			walker.call(node)
	)
