class_name SubtreeComments extends Node

@export var notes: Array[SceneComment]


func _enter_tree() -> void:
	queue_free()
