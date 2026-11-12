extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	DialogueManager.show_dialogue_balloon(load("res://tests/dialoguetest.dialogue"), "start")

			
func _on_dialogue_ended(resource):
	_enter_3d_space()

func _enter_3d_space():
	print("Dialogue finished, now in 3D mode")
