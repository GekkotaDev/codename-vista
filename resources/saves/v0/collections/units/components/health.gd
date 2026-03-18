extends PersistedV0

const Class := preload("./health.gd")

signal maximum_changed(maximum: int)
signal current_changed(current: int)

@export var maximum: int = -int(INF):
	get:
		return maximum
	set(value):
		maximum = value
		maximum_changed.emit(value)

@export var current: int = 1:
	get:
		return current
	set(value):
		current = value
		current_changed.emit(value)
