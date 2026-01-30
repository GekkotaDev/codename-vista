@abstract class_name NodeSelector
extends Node

@export var node_reference: Node


func _init() -> void:
	run(node_reference)


@abstract func run(node: Node) -> Error
