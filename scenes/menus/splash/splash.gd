@tool
extends Control

@export var target_scene: PackedScene
@export var animation_player: AnimationPlayer

@export_group("Developer Splash")
@export var splash_dev_textures: Array[TextureRect] = []
@export var splash_dev_zoom: float = 0.1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play(&"splash")
	animation_player.animation_finished.connect(
		func(_0):
			SceneManager.change_scene(target_scene)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for texture in splash_dev_textures:
		if texture.material == null:
			continue
		texture.material.set_shader_parameter(&"zoom_scale", splash_dev_zoom)
