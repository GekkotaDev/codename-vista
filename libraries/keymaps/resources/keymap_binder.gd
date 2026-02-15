class_name KeymapBinder
extends Resource

@export_group("Keyboard")
@export var keys: Dictionary[Key, KeymapModel]

@export_group("Controller")
@export var joy_sticks: Dictionary[JoyAxis, KeymapModel]
@export var joy_buttons: Dictionary[JoyButton, KeymapModel]


class QueryResult:
	var error = Error.OK
	var model: KeymapModel


func query(input: Variant) -> QueryResult:
	var result = QueryResult.new()

	if input is Key:
		result.model = keys[input]
		return result

	if input is JoyAxis:
		result.model = joy_sticks[input]
		return result

	if input is JoyButton:
		result.model = joy_buttons[input]
		return result

	result.error = Error.ERR_UNAVAILABLE
	return result
