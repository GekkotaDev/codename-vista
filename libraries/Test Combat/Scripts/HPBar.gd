extends ProgressBar

@export var entity_name: String = "Player" 

func _ready():
	# Wait one frame to ensure Player/Enemy have registered their HP first
	await get_tree().process_frame
	
	# Fetch from resource stored in HealthManager
	var data = HealthManager.get_entity_data(entity_name)
	
	if data:
		max_value = data.max_health
		value = data.current_health
		print("HPBar Debug: ", entity_name, " initialized with ", value, "/", max_value)
	
	# Connect to the global signal
	HealthManager.hp_changed.connect(_on_hp_changed)

func _on_hp_changed(name_of_entity: String, new_hp: int):
	if name_of_entity == entity_name:
		# Always check resource for max value
		var data = HealthManager.get_entity_data(entity_name)
		if data:
			max_value = data.max_health
		value = new_hp
