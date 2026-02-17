@tool
extends VBoxContainer

@export var entries: Dictionary[Control, Control] = { }

@export_group("Widths")
@export var minimum_label_size: Vector2
@export var minimum_keys_size: Vector2

@export_tool_button("Update")
var set_widths_action := set_widths


func set_widths():
	for node in entries.keys():
		var label: Label = node
		label.custom_minimum_size = minimum_label_size

	for node in entries.values():
		var control: Control = node
		control.custom_minimum_size = minimum_keys_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_widths()
