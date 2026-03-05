extends Node

var current_ui = null

func start_dialog(dialog_resource: HomelessDialogData, npc_node: Node):
	print("DEBUG: Dialog started with ", npc_node.name) # New safety check for debugging
	
	if dialog_resource == null:
		print("DialogManager Error: No dialog resource provided!")
		return

	# If UI doesn't exist, we need to create it
	if current_ui == null:
		# Ensure you have the DialogUI.tscn path correct here
		var ui_scene = load("res://libraries/Test Combat/Ui/Scenes/DialogUI.tscn") 
		if ui_scene:
			current_ui = ui_scene.instantiate()
			get_tree().root.add_child(current_ui)
			# IMPORTANT: Set the UI to process even when paused via code
			current_ui.process_mode = Node.PROCESS_MODE_ALWAYS
			# get_tree().root.add_child(current_ui) # Removed duplicate call
		else:
			print("DialogManager Error: Could not load DialogUI.tscn!")
			return

	# Get the name from the NPC node. 
	var n_name = "Unknown"
	if "entity_name" in npc_node:
		n_name = npc_node.entity_name
	elif "data" in npc_node and "entity_name" in npc_node.data:
		n_name = npc_node.data.entity_name

	# Pass both the resource AND the name to the UI
	current_ui.setup_dialog(dialog_resource, n_name)
	
	# Optional: Pauses everything
	get_tree().paused = true
