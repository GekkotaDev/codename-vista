# ! HEY !
# TODO: Fix the bug where my arrow keys don't even register.

# This isn't the most elegant code but eh, better done than perfect. It's not
# like we're gonna use this elsewhere except in the settings menu, right?
@tool
extends HBoxContainer

@export var accepted_inputs: AcceptedInputs
@export var keymaps_meta: KeymapBinder
@export var input_action: StringName
@export var label: String

@export_group("Private")
@export var _label: Label

@export_subgroup("")
@export var _input_button: Button
@export var _input_icon_input: TextureRect
@export var _input_icon_await: TextureRect

signal keymap_changed(serialized: String)

enum AcceptedInputs {
	KEYBOARD,
	GAMEPAD,
	ALL,
}

enum RebindState {
	IDLE,
	WAIT,
}

var state := RebindState.IDLE


func remap_icon(result: KeymapBinder.QueryResult) -> bool:
	if result.error != OK:
		return false

	_input_icon_input.texture = result.model.icon
	return true


func _editor_sync():
	_label.text = label

	# var input := InputHelper.get_keyboard_input_for_action(input_action)

	# if input is InputEventKey:
	# 	remap_icon(keymaps_meta.query(input.keycode))

	# if input is InputEventJoypadButton:
	# 	remap_icon(keymaps_meta.query(input.button_index))

	# if input is InputEventJoypadMotion:
	# 	remap_icon(keymaps_meta.query(input.axis))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_label.text = label

	_input_icon_input.visible = true
	_input_icon_await.visible = false

	_input_button.pressed.connect(
		func():
			_input_icon_input.visible = false
			_input_icon_await.visible = true
			state = RebindState.WAIT
	)

	var input := InputHelper.get_keyboard_input_for_action(input_action)

	if input is InputEventKey:
		remap_icon(keymaps_meta.query(input.keycode))

	if input is InputEventJoypadButton:
		remap_icon(keymaps_meta.query(input.button_index))

	if input is InputEventJoypadMotion:
		remap_icon(keymaps_meta.query(input.axis))


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_editor_sync()


func _unhandled_input(event: InputEvent) -> void:
	if state == RebindState.IDLE:
		return accept_event()

	if (
		(
			accepted_inputs == AcceptedInputs.KEYBOARD
			or accepted_inputs == AcceptedInputs.ALL
		)
		and event is InputEventKey
	):
		accept_event()
		var result := remap_icon(keymaps_meta.query(event.keycode))
		_input_icon_input.visible = true
		_input_icon_await.visible = false
		state = RebindState.IDLE
		if result:
			keymap_changed.emit(InputHelper.serialize_inputs_for_actions([input_action]))
			InputHelper.set_keyboard_input_for_action(input_action, event)

	if (
		(
			accepted_inputs == AcceptedInputs.GAMEPAD
			or accepted_inputs == AcceptedInputs.ALL
		)
		and event is InputEventJoypadButton
	):
		accept_event()
		var result := remap_icon(keymaps_meta.query(event.button_index))
		_input_icon_input.visible = true
		_input_icon_await.visible = false
		state = RebindState.IDLE
		if result:
			keymap_changed.emit(InputHelper.serialize_inputs_for_actions([input_action]))
			InputHelper.set_joypad_input_for_action(input_action, event)

	if (
		(
			accepted_inputs == AcceptedInputs.GAMEPAD
			or accepted_inputs == AcceptedInputs.ALL
		)
		and event is InputEventJoypadMotion
	):
		accept_event()
		var result := remap_icon(keymaps_meta.query(event.axis))
		_input_icon_input.visible = true
		_input_icon_await.visible = false
		state = RebindState.IDLE
		if result:
			keymap_changed.emit(InputHelper.serialize_inputs_for_actions([input_action]))
			InputHelper.set_joypad_input_for_action(input_action, event)

	if event is InputEventMouseButton:
		_input_icon_input.visible = true
		_input_icon_await.visible = false
		state = RebindState.IDLE
		return accept_event()
