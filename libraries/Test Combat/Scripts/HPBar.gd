extends ProgressBar

@export var entity_name: String = "Player" 

func _ready():
	# --- ORIGINAL CODE (Turned into comments) ---
	# # Wait one frame to ensure Player/Enemy have registered their HP first
	# await get_tree().process_frame
	# 
	# # Fetch from resource stored in HealthManager
	# var data = HealthManager.get_entity_data(entity_name)
	# 
	# if data:
	# 	max_value = data.max_health
	# 	value = data.current_health
	# 	print("HPBar Debug: ", entity_name, " initialized with ", value, "/", max_value)
	# 
	# # Connect to the global signal
	# HealthManager.hp_changed.connect(_on_hp_changed)

	# --- NEW UPDATED LOGIC ---
	# 1. Wait three frames to be absolutely sure the DuplicateManager and HealthManager are finished
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	# 2. Find the owner node (Player or NPC)
	# We climb up the tree until we find a node with 'entity_name'
	var parent_node = get_parent()
	while parent_node != null:
		if "entity_name" in parent_node:
			self.entity_name = parent_node.entity_name
			break
		parent_node = parent_node.get_parent()
		
	# 3. Pull current data from HealthManager
	var data = HealthManager.get_entity_data(self.entity_name)
	
	if data and data.has_method("get"):
		max_value = data.get("max_health")
		value = data.get("current_health")
		print("HPBar Success: Linked to ", self.entity_name, " with HP: ", value)
	else:
		print("HPBar Error: Could not find data for ", self.entity_name)
	
	# 4. Connect to the global signal
	if not HealthManager.hp_changed.is_connected(_on_hp_changed):
		HealthManager.hp_changed.connect(_on_hp_changed)

func _on_hp_changed(name_of_entity: String, new_hp: int):
	# Update only if the signal matches this bar's specific NPC/Player
	if name_of_entity == self.entity_name:
		value = new_hp
		# Ensure max_value stays synced if it ever changes
		var data = HealthManager.get_entity_data(self.entity_name)
		if data and data.has_method("get"):
			max_value = data.get("max_health")
