@tool
class_name SettingVolumeSFX
extends GGSSetting

func _init() -> void:
	section = "audio"
	key = "volume.sfx"
	type = TYPE_FLOAT
	default = 1.0


func apply(value: float):
	pass
