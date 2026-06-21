extends PersistedV0

const Class := preload("./flag.gd")

signal updated

var name := ""


func _void():
	updated.get_name()


class Flag extends Class:
	@export var activated := false:
		get:
			return activated
		set(value):
			activated = value
			updated.emit()


class Text extends Class:
	@export var text := "":
		get:
			return text
		set(value):
			text = value
			updated.emit()


class Integer extends Class:
	@export var integer := -1:
		get:
			return integer
		set(value):
			integer = value
			updated.emit()


class Float extends Class:
	@export var number := -INF:
		get:
			return number
		set(value):
			number = value
			updated.emit()
