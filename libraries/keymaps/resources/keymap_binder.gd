class_name KeymapBinder
extends Resource

@export var fallbacks: Array[KeymapBinder] = []

@export_group("Inputs")
@export var keys: Dictionary[Key, KeymapModel] = { }
@export var joy_sticks: Dictionary[JoyAxis, KeymapModel] = { }
@export var joy_buttons: Dictionary[JoyButton, KeymapModel] = { }


class QueryResult:
	var error := Error.OK
	var model: KeymapModel


func query(input: Variant) -> QueryResult:
	var result = QueryResult.new()

	if input is Key and input in keys:
		result.model = keys[input]
		return result

	if input is JoyAxis and input in joy_sticks:
		result.model = joy_sticks[input]
		return result

	if input is JoyButton and input in joy_buttons:
		result.model = joy_buttons[input]
		return result

	for fallback in fallbacks:
		result = fallback.query(input)
		if result.error == Error.OK:
			return result

	if input[KEY_NONE] in keys:
		result.model = input[KEY_NONE]
		return result

	if input[JOY_AXIS_INVALID] in joy_sticks:
		result.model = input[JOY_AXIS_INVALID]
		return result

	if input[JOY_BUTTON_INVALID] in joy_buttons:
		result.model = input[JOY_BUTTON_INVALID]
		return result

	result.error = Error.ERR_UNAVAILABLE
	return result
