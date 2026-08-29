extends Control

@export var target_scene: PackedScene

@export_category("Debug")
@export var _debug_scene: PackedScene


func _debug() -> void:
	SceneManager.change_scene(_debug_scene)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (OS.is_debug_build()) and _debug_scene != null:
		_debug()
		return

	SceneManager.change_scene(target_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
