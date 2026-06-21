@tool
extends GGSSetting

class_name SettingSpeedrunTimer

func _init() -> void:
	type = TYPE_BOOL
	default = true
	section = "gameplay"
	key = "speedrun_timer"


## TODO: Apply value.
func apply(_value: bool) -> void:
	pass
