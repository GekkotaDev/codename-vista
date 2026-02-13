## Sets the max FPS of the game.
@tool
class_name SettingMaxFPS
extends GGSSetting

enum FPS {
	CINEMATIC,
	HALVED,
	SMOOTH,
}


func _init() -> void:
	type = TYPE_INT
	hint = PROPERTY_HINT_ENUM
	hint_string = "24,30,60"
	default = 2
	section = "display"
	key = "video.max_fps"


func apply(value: int) -> void:
	match value:
		FPS.CINEMATIC:
			Engine.max_fps = 24
		FPS.HALVED:
			Engine.max_fps = 30
		FPS.SMOOTH:
			Engine.max_fps = 60
