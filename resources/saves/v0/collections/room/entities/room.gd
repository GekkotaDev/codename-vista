extends PersistedV0

const Class := preload("./room.gd")

@export var connections: Dictionary[String, Class] = { }
@export var flags: Array[SaveSchemaV0.UseFlags.Components.Flag] = []
@export var scene_id := &""


class NullRoom extends Class:
	func _init() -> void:
		scene_id = &"null"
