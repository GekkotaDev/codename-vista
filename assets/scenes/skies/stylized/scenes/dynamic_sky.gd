@tool
extends WorldEnvironment

@export var animation_player: AnimationPlayer
@export var cycle := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if animation_player:
		animation_player.current_animation = "daylight_cycle"
	if cycle:
		animation_player.play(&"daylight_cycle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
