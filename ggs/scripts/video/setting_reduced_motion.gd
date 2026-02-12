@tool
extends GGSSetting

class_name SettingReducedMotion

func _init() -> void:
	type = TYPE_BOOL
	default = false
	section = "display"
	key = "video.reduced_motion"


## TODO: Apply value.
func apply(_value: bool) -> void:
	pass
