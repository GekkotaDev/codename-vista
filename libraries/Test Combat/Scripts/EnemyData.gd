extends Resource
class_name EnemyData

@export var name: String = "Enemy"
@export var max_health: int = 50
@export var current_health: int = 50
@export var attack_damage: int = 10

# Track if this specific enemy instance is poisoned
var is_poisoned: bool = false

# Variable to hold the calculated stacking poison damage
var current_poison_damage: int = 0
