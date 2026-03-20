@tool
class_name SettingAudioAmbient
extends GGSSetting

func _init() -> void:
	type = TYPE_FLOAT
	hint = PROPERTY_HINT_RANGE
	hint_string = "0,1,0.01"
	default = 0.80
	section = "audio"
	key = "volume.ambient"


func apply(value: float) -> void:
	SoundManager.set_ambient_sound_volume(value)
