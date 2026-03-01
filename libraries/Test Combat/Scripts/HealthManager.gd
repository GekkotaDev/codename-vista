extends Node

# Global Autoload to store health for anyone in the game
var health_data = {}
var max_health_data = {}

# Signal to notify UI and bars when health changes
signal hp_changed(entity_name, new_hp)

# Call this from the Player or Enemy's _ready() function
func register_entity(entity_name: String, max_hp: int):
	if not health_data.has(entity_name):
		max_health_data[entity_name] = max_hp
		health_data[entity_name] = max_hp
		print("HealthManager: Registered ", entity_name, " with ", max_hp, " HP")
	else:
		max_health_data[entity_name] = max_hp

func get_hp(entity_name: String) -> int:
	return health_data.get(entity_name, 0)

func update_hp(entity_name: String, amount: int):
	if not health_data.has(entity_name):
		print("HealthManager Error: '", entity_name, "' is not registered!")
		return
	
	# Apply the damage or healing
	health_data[entity_name] += amount
	
	# Clamp between 0 and Max HP
	var max_hp = max_health_data.get(entity_name, 100)
	health_data[entity_name] = clamp(health_data[entity_name], 0, max_hp)
	
	# --- Signal notifies any bar listening for this entity ---
	hp_changed.emit(entity_name, health_data[entity_name])
	
	print("Health Update: ", entity_name, " is now at ", health_data[entity_name], "/", max_hp)
