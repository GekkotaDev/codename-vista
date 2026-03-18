extends PersistedV0

const Class := preload("./room.gd")

@export var connections: Dictionary[String, Class] = { }
@export var events: Array[SaveSchemaV0.Room.Components.Event] = []
@export var scene_id := &""


class NullRoom extends Class:
	func _init() -> void:
		scene_id = &"null"
