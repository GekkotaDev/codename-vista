@tool
extends Control

@export var texture: CompressedTexture2D

@export_group("Background")
@export var background_color: Color = Color.WHITE
@export var background_shader: ShaderMaterial
@export var background_texture: CompressedTexture2D

@export_group("Foreground")
@export var foreground_color: Color = Color.WHITE
@export var foreground_shader: ShaderMaterial
@export var foreground_texture: CompressedTexture2D

@export_group("Internals")
@export var _texture: TextureRect
@export var _background_texture: TextureRect
@export var _foreground_texture: TextureRect


func initialize_materials():
	_texture.texture = texture
	
	_background_texture.texture = background_texture
	_background_texture.material = background_shader
	_background_texture.self_modulate = background_color
	
	_foreground_texture.texture = foreground_texture
	_foreground_texture.material = foreground_shader
	_foreground_texture.self_modulate = foreground_color


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_materials()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		initialize_materials()
