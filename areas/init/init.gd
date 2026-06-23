extends Control

@export var target_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.change_scene(target_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
