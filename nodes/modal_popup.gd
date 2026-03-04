class_name ModalPopup
extends Control

@export var scene: Node
@export var modal: PackedScene


func _set_scene_processors(toggle: bool):
	scene.set_process_input(toggle)
	scene.set_process_shortcut_input(toggle)
	scene.set_process_unhandled_input(toggle)
	scene.set_process_unhandled_key_input(toggle)


func open(callback: Callable = func(): pass):
	_set_scene_processors(false)
	callback.call()


func close(callback: Callable = func(): pass):
	callback.call()
	_set_scene_processors(true)
