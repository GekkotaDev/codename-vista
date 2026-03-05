extends Node

# Store the entire Resource object
var entities = {}

# Signal to notify UI and bars when health changes
signal hp_changed(entity_name, new_hp)

# Call this from the Player or Enemy's _ready() function
func register_entity(entity_resource: Resource):
	# --- ORIGINAL CODE (Turned into comments) ---
	# if not entities.has(entity_resource.name):
	# 	entities[entity_resource.name] = entity_resource
	# 	print("HealthManager: Registered ", entity_resource.name)
	# else:
	# 	# Update reference if it already exists
	# 	entities[entity_resource.name] = entity_resource

	# --- NEW UPDATED LOGIC ---
	var entity_name = "Unknown"
	if "name" in entity_resource:
		entity_name = entity_resource.get("name")
	
	entities[entity_name] = entity_resource
	
	# --- ORIGINAL CRASHING LINE (Turned into comment) ---
	# hp_changed.emit(entity_name, entity_resource.current_health)

	# --- FIXED SAFE ACCESS ---
	var hp_val = 0
	if "current_health" in entity_resource:
		hp_val = entity_resource.get("current_health")
	
	hp_changed.emit(entity_name, hp_val)
	print("HealthManager: Registered unique entity ", entity_name)

# Get the whole resource
func get_entity_data(entity_name: String):
	return entities.get(entity_name)

func get_hp(entity_name: String) -> int:
	if entities.has(entity_name):
		# Safe access for HP
		return entities[entity_name].get("current_health")
	return 0

func update_hp(entity_name: String, amount: int):
	if not entities.has(entity_name):
		print("HealthManager Error: '", entity_name, "' is not registered!")
		return
	
	var data = entities[entity_name]
	
	# --- FIXED SAFE HP UPDATE ---
	var current_hp = data.get("current_health")
	var max_hp = data.get("max_health")
	
	current_hp += amount
	current_hp = clamp(current_hp, 0, max_hp)
	
	data.set("current_health", current_hp)
	
	# Signal notifies any bar listening for this entity
	hp_changed.emit(entity_name, current_hp)
	
	print("Health Update: ", entity_name, " is now at ", current_hp, "/", max_hp)

# NEW: Cleanup function to remove the unique resource from the Dictionary
# This allows the duplicated resource to be freed from RAM when the NPC is gone.
func unregister_entity(entity_resource: Resource):
	var entity_name = "Unknown"
	if "name" in entity_resource:
		entity_name = entity_resource.get("name")
	
	if entities.has(entity_name):
		entities.erase(entity_name)
		print("HealthManager: Unregistered ", entity_name, " memory released.")
