@tool
extends GGSSetting

class_name SettingFocusLossPause

func _init() -> void:
	type = TYPE_BOOL
	default = true
	section = "gameplay"
	key = "focus_loss_pause"


## TODO: Apply value.
func apply(_value: bool) -> void:
	pass
