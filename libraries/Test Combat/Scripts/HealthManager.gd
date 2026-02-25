extends Node

# Global Autoload to store health for anyone in the game
# Key: Node Name or Unique ID | Value: Current HP
var health_data = {
	"Player": 100
}

var max_health_data = {
	"Player": 100
}

func get_hp(entity_name: String) -> int:
	return health_data.get(entity_name, 100)

func update_hp(entity_name: String, amount: int):
	if not health_data.has(entity_name):
		health_data[entity_name] = 100 # Default if not found
	
	health_data[entity_name] += amount
	# Clamp between 0 and Max HP
	health_data[entity_name] = clamp(health_data[entity_name], 0, max_health_data.get(entity_name, 100))
	
	# Emit a signal so the UI knows to update
	emit_signal("hp_changed", entity_name, health_data[entity_name])

signal hp_changed(entity_name, new_hp)
