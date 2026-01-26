class_name ModelBinder
extends Control

@export var model: ResourceModel
@export var bindings: Dictionary[String, String] = { }


func _ready() -> void:
	model.subscribe(
		func(state: Dictionary[StringName, Variant]):
			for property in bindings:
				set(property, state[bindings[property]])
	)
