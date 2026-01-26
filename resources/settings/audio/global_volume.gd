@tool
class_name SettingVolumeGlobal
extends GGSSetting

func _init() -> void:
	section = "audio"
	key = "volume.global"
	type = TYPE_FLOAT
	default = 1.0


func apply(value: float):
	pass
