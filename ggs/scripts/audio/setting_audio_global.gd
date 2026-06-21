@tool
class_name SettingAudioGlobal
extends GGSSetting
## Sets the volume of an audio bus.

## Target audio bus.
var audio_bus: String = "None"


func _init() -> void:
	type = TYPE_FLOAT
	hint = PROPERTY_HINT_RANGE
	hint_string = "0,1"
	default = 0.80
	section = "audio"
	key = "volume.global"


func _get_property_list() -> Array:
	return [
		{
			"name": "audio_bus",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(_get_audio_bus_list()),
		},
	]


func apply(value: float) -> void:
	var bus_idx: int = AudioServer.get_bus_index(audio_bus)
	var volume_db: float = linear_to_db((value * 100) / 100)
	AudioServer.set_bus_volume_db(bus_idx, volume_db)


func _get_audio_bus_list() -> PackedStringArray:
	var buses: PackedStringArray
	for bus_idx: int in range(AudioServer.bus_count):
		var bus: String = AudioServer.get_bus_name(bus_idx)
		buses.append(bus)
	return buses
