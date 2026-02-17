# I could think of something more elegant but meh.
@tool
extends HBoxContainer

@export var accepted_inputs = ["keyboard", "gamepad"]
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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	accepted_inputs = accepted_inputs.map(
		func(accepted_input: String): return accepted_input.to_lower()
	)

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
		_label.text = label


func _unhandled_input(event: InputEvent) -> void:
	if state == RebindState.IDLE:
		return accept_event()

	if "keyboard" in accepted_inputs and event is InputEventKey and event.is_pressed():
		accept_event()
		var result := remap_icon(keymaps_meta.query(event.keycode))
		if result:
			keymap_changed.emit(InputHelper.serialize_inputs_for_actions([input_action]))
			InputHelper.set_keyboard_input_for_action(input_action, event)

	if "gamepad" in accepted_inputs and event is InputEventJoypadButton and event.is_pressed():
		accept_event()
		var result := remap_icon(keymaps_meta.query(event.button_index))
		if result:
			keymap_changed.emit(InputHelper.serialize_inputs_for_actions([input_action]))
			InputHelper.set_joypad_input_for_action(input_action, event)

	if "gamepad" in accepted_inputs and event is InputEventJoypadMotion and event.is_pressed():
		accept_event()
		var result := remap_icon(keymaps_meta.query(event.axis))
		if result:
			keymap_changed.emit(InputHelper.serialize_inputs_for_actions([input_action]))
			InputHelper.set_joypad_input_for_action(input_action, event)

	if event is InputEventMouseButton:
		return accept_event()

	_input_icon_input.visible = true
	_input_icon_await.visible = false
	state = RebindState.IDLE
