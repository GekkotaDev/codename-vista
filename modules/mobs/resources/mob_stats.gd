class_name MobStats
extends Resource

@export_group("Health")
@export var default_health: int
@export var current_health: int = default_health:
	get:
		return current_health
	set(value):
		current_health = value
		if current_health < 0:
			current_health = 0

@export_group("Defense")
@export var default_defense: int
@export var current_defense: int = default_defense:
	get:
		return current_defense
	set(value):
		current_defense = value
		if current_defense < 0:
			current_defense = 0

@export_group("Speed")
@export var default_speed: int
@export var current_speed: int = default_speed:
	get:
		return current_speed
	set(value):
		current_speed = value
		if current_speed < 0:
			current_speed = 0

@export_group("Attack")
@export var default_attack: int
@export var current_attack: int = default_attack:
	get:
		return current_attack
	set(value):
		current_attack = value
		if current_attack < 0:
			current_attack = 0
