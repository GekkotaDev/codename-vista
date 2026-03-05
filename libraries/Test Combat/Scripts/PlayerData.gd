extends Resource
class_name PlayerData

@export var name: String = "Player"
@export var max_health: int = 100
@export var current_health: int = 100

# Basic Attack
@export var basic_attack_damage: int = 15

# Poison Attack
@export var poison_attack_initial_damage: int = 2
@export var poison_damage_per_tick: int = 2
@export var poison_duration: float = 5.0 
@export var poison_tick_rate: float = 1.0 
