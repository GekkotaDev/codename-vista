extends ProgressBar

@export var entity_name: String = "Player" 

func _ready():
	# Wait one frame to ensure Player/Enemy have registered their HP first
	await get_tree().process_frame
	
	# Fetches the data from healthmanager the 100 here "(entity_name, 100)" is just in case
	# the entity doesn't have a max health value or healthmanager can't find it's max health
	var max_hp = HealthManager.max_health_data.get(entity_name, 100)
	var current_hp = HealthManager.get_hp(entity_name)
	
	# Set the bar values
	max_value = max_hp
	value = current_hp
	
	print("HPBar Debug: ", entity_name, " initialized with ", value, "/", max_value)
	
	# Connect to the global signal
	HealthManager.hp_changed.connect(_on_hp_changed)

func _on_hp_changed(name_of_entity: String, new_hp: int):
	if name_of_entity == entity_name:
		# Always ensure max_value is current too, just in case
		max_value = HealthManager.max_health_data.get(entity_name, 100)
		value = new_hp
