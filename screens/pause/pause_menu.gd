## !NOTE:
##
## https://docs.godotengine.org/en/latest/tutorials/scripting/pausing_games.html
## As per the Godot documentation pausing behavior should be implemented
extends Control

@export_group("Transitions")
@export var in_transition: AnimationController
@export var in_transition_sound: AudioStream
@export var out_transition: AnimationController
@export var out_transition_sound: AudioStream

# Called when the node enters the scene tree for the first time.
# func _ready() -> void:
# 	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass


func _enter_tree() -> void:
	var tree := get_tree()

	tree.paused = true

	if in_transition_sound:
		SoundManager.play_ui_sound(in_transition_sound)

	if in_transition:
		in_transition.start()


func _exit_tree() -> void:
	var tree := get_tree()

	if out_transition_sound:
		SoundManager.play_ui_sound(out_transition_sound)

	if out_transition:
		out_transition.animation_ended.connect(
			func():
				tree.paused = false,
			CONNECT_ONE_SHOT,
		)
		out_transition.start()
	else:
		tree.paused = false
