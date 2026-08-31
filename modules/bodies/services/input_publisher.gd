@abstract
class_name InputSource3D
extends Resource

@export var id: String
@export var active: bool = true

@export var direction: Vector2 = Vector2.ZERO
@export var effects: PackedStringArray = []
@export var jumped: bool = false


##
@abstract func poll() -> void
