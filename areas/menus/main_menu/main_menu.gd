extends Node2D

const GAME_SCENE_PATH := "res://areas/Levels/1-TheForest/Prologue.tscn"

@onready var play_button: Button = $Button_Manager/Play
@onready var quit_button: Button = $Button_Manager/Quit

func _ready() -> void:
	Hud.hide()

func _on_play_pressed() -> void:
	play_button.disabled = true
	SceneTransition.change_scene(GAME_SCENE_PATH)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _exit_tree() -> void:
	Hud.show()
