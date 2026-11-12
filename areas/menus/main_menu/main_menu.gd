extends Node2D

const GAME_SCENE_PATH := "res://areas/zones/Prologue/Prologue.tscn"

func _ready() -> void:
	Hud.visible = false

func _on_play_pressed() -> void:
	SceneTransition.change_scene(GAME_SCENE_PATH)
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _exit_tree() -> void:
	Hud.visible = true
