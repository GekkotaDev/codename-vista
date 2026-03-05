extends Node

# Store the entire Resource object
var entities = {}

# Signal to notify UI and bars when health changes
signal hp_changed(entity_name, new_hp)

# Call this from the Player or Enemy's _ready() function
func register_entity(entity_resource: Resource):
	if not entities.has(entity_resource.name):
		entities[entity_resource.name] = entity_resource
		print("HealthManager: Registered ", entity_resource.name)
	else:
		# Update reference if it already exists
		entities[entity_resource.name] = entity_resource

# Get the whole resource
func get_entity_data(entity_name: String):
	return entities.get(entity_name)

func get_hp(entity_name: String) -> int:

	if entities.has(entity_name):
		return entities[entity_name].current_health
	return 0

func update_hp(entity_name: String, amount: int):
	if not entities.has(entity_name):
		print("HealthManager Error: '", entity_name, "' is not registered!")
		return
	
	var data = entities[entity_name]
	
	# Apply the damage or healing to the resource variable
	data.current_health += amount
	
	# Clamp between 0 and Max HP
	data.current_health = clamp(data.current_health, 0, data.max_health)
	
	# Signal notifies any bar listening for this entity
	hp_changed.emit(entity_name, data.current_health)
	
	print("Health Update: ", entity_name, " is now at ", data.current_health, "/", data.max_health)
