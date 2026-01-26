class_name ShaderController
extends Node

@export var shaders: Dictionary[String, Control]


func write(node: String, parameter: String, value: Variant):
	var shader_parameter := "shader_parameter/{parameter}".format(
		{
			format = parameter,
		},
	)

	shaders[node].material.set(shader_parameter, value)

	return self
