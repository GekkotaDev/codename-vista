extends PersistedV0

const Class := preload("./event.gd")

signal on_update

@export var name := ""


func _void():
	on_update.get_name()


class Flag extends Class:
	@export var activated := false:
		get:
			return activated
		set(value):
			activated = value
			on_update.emit()


class Text extends Class:
	@export var text := "":
		get:
			return text
		set(value):
			text = value
			on_update.emit()


class Integer extends Class:
	@export var integer := -1:
		get:
			return integer
		set(value):
			integer = value
			on_update.emit()


class Float extends Class:
	@export var number := -INF:
		get:
			return number
		set(value):
			number = value
			on_update.emit()
