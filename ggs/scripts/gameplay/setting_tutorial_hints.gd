@tool
extends GGSSetting

class_name SettingTutorialHints

func _init() -> void:
	type = TYPE_BOOL
	default = true
	section = "gameplay"
	key = "tutorial_hints"


## TODO: Apply value.
func apply(_value: bool) -> void:
	pass
