@tool
class_name SettingVolumeMusic
extends GGSSetting

func _init() -> void:
	section = "audio"
	key = "volume.music"
	type = TYPE_FLOAT
	default = 1.0


func apply(value: float):
	pass
