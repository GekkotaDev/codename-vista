@tool
class_name SettingAudioMusic
extends GGSSetting

func _init() -> void:
	type = TYPE_FLOAT
	hint = PROPERTY_HINT_RANGE
	hint_string = "0,1,0.01"
	default = 1
	section = "audio"
	key = "volume.music"


func apply(value: float) -> void:
	SoundManager.set_music_volume(value)
