extends Node

# --- ORIGINAL CODE (Turned into comments - This was the Dialog Logic accidentally pasted here) ---
# var current_ui = null
# var current_dialog = null 
# 
# func start_dialog(dialog_resource: Resource, npc_node: Node):
# 	print("DEBUG: Dialog started with ", npc_node.name)
# 	if dialog_resource == null: return
# 	current_dialog = dialog_resource
# 	if current_ui == null:
# 		var ui_scene = load("res://libraries/Test Combat/Ui/Scenes/DialogUI.tscn") 
# 		if ui_scene:
# 			current_ui = ui_scene.instantiate()
# 			get_tree().root.add_child(current_ui)
# 			current_ui.process_mode = Node.PROCESS_MODE_ALWAYS
# 	var n_name = "Unknown"
# 	if "entity_name" in npc_node: n_name = npc_node.entity_name
# 	current_ui.setup_dialog(dialog_resource, npc_node)
# 	get_tree().paused = true

# --- NEW UPDATED LOGIC (The actual DuplicateManager functions) ---

var resource_counters = {}

func get_duplicate_resource(original_res: Resource) -> Resource:
	if original_res == null: 
		return null
	
	# Use 'true' for Deep Copy to ensure Arrays/Sub-resources are unique
	var new_res = original_res.duplicate(true)
	
	var base_name = "NPC_Resource"
	
	# Check if the resource has a name property
	if "name" in new_res:
		var res_name = new_res.get("name")
		if res_name != null and res_name != "":
			base_name = res_name
	elif original_res is HomelessDialogData:
		base_name = "Dialog"
	elif original_res is CrazyHomelessDialogData:
		base_name = "CrazyDialog"
	
	# Don't duplicate the Player's base stats if they are already unique
	if base_name == "Player":
		return new_res
	
	# Increment the counter for this unique ID
	if not resource_counters.has(base_name):
		resource_counters[base_name] = 0
	resource_counters[base_name] += 1
	
	var unique_id = base_name + "_" + str(resource_counters[base_name])
	
	# Apply the new unique name so HealthManager can track it individually
	if "name" in new_res:
		new_res.set("name", unique_id)
			
	return new_res
