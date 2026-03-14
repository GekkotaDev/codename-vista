extends Node

# --- ORIGINAL CODE (Turned into comments) ---
# var current_ui = null
# var current_dialog = null 
# 
# func start_dialog(dialog_resource: HomelessDialogData, npc_node: Node):
# 	print("DEBUG: Dialog started with ", npc_node.name)
# 	
# 	if dialog_resource == null:
# 		print("DialogManager Error: No dialog resource provided!")
# 		return
# 		
# 	current_dialog = dialog_resource
# 
# 	if current_ui == null:
# 		var ui_scene = load("res://libraries/Test Combat/Ui/Scenes/DialogUI.tscn") 
# 		if ui_scene:
# 			current_ui = ui_scene.instantiate()
# 			get_tree().root.add_child(current_ui)
# 			current_ui.process_mode = Node.PROCESS_MODE_ALWAYS
# 		else:
# 			print("DialogManager Error: Could not load DialogUI.tscn!")
# 			return
# 
# 	var n_name = "Unknown"
# 	if "entity_name" in npc_node:
# 		n_name = npc_node.entity_name
# 	elif "data" in npc_node and "entity_name" in npc_node.data:
# 		n_name = npc_node.data.entity_name
# 
# 	current_ui.setup_dialog(dialog_resource, n_name)
# 	get_tree().paused = true

# --- NEW UPDATED LOGIC ---
var current_ui = null
var current_dialog = null # Track the resource for memory cleanup

# --- NEW FUNCTION TO FIX THE ERROR ---
# This allows NPC.gd to call setup_dialog directly on this manager
func setup_dialog(dialog_resource: Resource, npc_node: Node, player_node: Node = null):
	# We redirect this call to our existing start_dialog logic, 
	# but ensure the player reference is carried through.
	start_dialog(dialog_resource, npc_node, player_node)

# Changed dialog_resource type to Resource to allow any Dialog Data script
# Added optional player_node parameter to ensure reference persistence
func start_dialog(dialog_resource: Resource, npc_node: Node, player_node: Node = null):
	print("DEBUG: Dialog started with ", npc_node.name)
	
	if dialog_resource == null:
		print("DialogManager Error: No dialog resource provided!")
		return
		
	# Store reference so we can clear it later if the NPC dies
	current_dialog = dialog_resource

	# --- NEW UPDATED LOGIC (Instance Check) ---
	# Because DialogUI now calls queue_free(), we must check if the old reference is dead.
	# is_instance_valid() returns false if the node was destroyed.
	if not is_instance_valid(current_ui):
		current_ui = null

	if current_ui == null:
		var ui_scene = load("res://libraries/Test Combat/Ui/Scenes/DialogUI.tscn") 
		if ui_scene:
			current_ui = ui_scene.instantiate()
			# Use call_deferred to ensure UI is added safely outside of physics steps
			get_tree().root.add_child.call_deferred(current_ui)
			current_ui.process_mode = Node.PROCESS_MODE_ALWAYS
		else:
			print("DialogManager Error: Could not load DialogUI.tscn!")
			return

	# --- NEW UPDATED LOGIC (Chain of Custody Fix) ---
	# We MUST wait for the UI to be ready, but we must keep the player reference
	if not current_ui.is_inside_tree():
		await current_ui.tree_entered # Wait specifically for the UI to enter tree
	
	# Small extra wait to ensure @onready variables are hit
	if not current_ui.is_node_ready():
		await current_ui.ready

	# --- ORIGINAL CODE (Turned into comments) ---
	# current_ui.setup_dialog(dialog_resource, npc_node)
	
	# Pass all three references to DialogUI.gd
	if current_ui.has_method("setup_dialog"):
		current_ui.setup_dialog(dialog_resource, npc_node, player_node)
		get_tree().paused = true
	else:
		print("DEBUG ERROR: DialogUI does not have setup_dialog function!")

# Cleanup function to release the duplicated Resource from memory
func clear_dialog_ref(resource_to_clear: Resource):
	if current_dialog == resource_to_clear:
		current_dialog = null
		print("DialogManager: Reference to unique dialog cleared.")
