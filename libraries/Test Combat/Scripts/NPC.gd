@tool # This allows the script to run in the Editor/Inspector
extends CharacterBody3D

@export var is_hostile: bool = false
# --- ORIGINAL CODE (Turned into comments) ---
# @export var dialog_resource: HomelessDialogData:
# 	set(val):
# 		if Engine.is_editor_hint() and val != null:
# 			dialog_resource = val.duplicate(true)
# 		else:
# 			dialog_resource = val

# --- NEW UPDATED LOGIC ---
# Changed to Resource so it can accept ANY dialog type (Crazy or Standard)
@export var dialog_resource: Resource:
	set(val):
		# --- ORIGINAL CODE (Turned into comments) ---
		# dialog_resource = val
		
		# --- NEW UPDATED LOGIC ---
		# If we are in the editor and we assign a resource, 
		# we immediately duplicate it so it becomes unique to THIS NPC.
		if Engine.is_editor_hint() and val != null:
			dialog_resource = val.duplicate(true)
		else:
			dialog_resource = val

@export var data: Resource: # Holds Health/Stats
	set(val):
		# --- ORIGINAL CODE (Turned into comments) ---
		# data = val
		
		# --- NEW UPDATED LOGIC ---
		if Engine.is_editor_hint() and val != null:
			data = val.duplicate(true)
		else:
			data = val

@export var entity_name: String = "Homeless Person" # Change this in Inspector for different NPCs

# --- NEW LOGIC VARIABLE ---
var is_in_combat: bool = false

func _ready():
	# --- ORIGINAL CODE (Turned into comments) ---
	# if data:
	# 	HealthManager.register_entity(data)
	# 
	# if is_hostile:
	# 	
	# 	# NEW: Swap to the HostileNPC script to keep code clean
	# 	var saved_data = data # Save data before swap
	# 	var hostile_script = load("res://libraries/Test Combat/Scripts/HostileNPC.gd")
	# 	set_script(hostile_script)
	# 	
	# 	# Re-assign data and trigger the new _ready() because
	# 	self.data = saved_data
	# 	if has_method("_ready"):
	# 		_ready()
	# else:
	# 	set_process(false)

	# --- NEW UPDATED LOGIC ---
	
	# If not in editor, ensure we are using the unique copies
	if not Engine.is_editor_hint():
		if dialog_resource:
			dialog_resource = DuplicateManager.get_duplicate_resource(dialog_resource)

		if data:
			data = DuplicateManager.get_duplicate_resource(data)
			
			if data.has_method("set"):
				data.set("name", self.entity_name)
				data = DuplicateManager.get_duplicate_resource(data)
				
				var unique_name = data.get("name")
				if unique_name:
					self.entity_name = unique_name
				
			HealthManager.register_entity(data)
			
			# --- NEW DEATH LISTENER ---
			# Connecting to the HealthManager signal instead of the resource signal 
			# to ensure the NPC knows when it is defeated in combat.
			if HealthManager.has_signal("entity_died"):
				HealthManager.connect("entity_died", _on_global_death_check)
		
		if is_hostile:
			var saved_data = data 
			var saved_name = self.entity_name
			var saved_dialog = dialog_resource
			
			var hostile_script = load("res://libraries/Test Combat/Scripts/HostileNPC.gd")
			set_script(hostile_script)
			
			self.set("data", saved_data)
			self.set("entity_name", saved_name)
			self.set("dialog_resource", saved_dialog)
			
			if has_method("_ready"):
				_ready()
		else:
			set_process(false)

# --- NEW CLEANUP LOGIC ---
func _on_global_death_check(dead_data_ref):
	# We check if the data that just died matches THIS NPC's unique data
	if dead_data_ref == self.data:
		print("DEBUG: NPC ", entity_name, " matches dead entity. Removing...")
		if dialog_resource:
			DialogManager.clear_dialog_ref(dialog_resource)
		queue_free()

func interact():
	# --- NEW UPDATED LOGIC (Combat Guard) ---
	# If we are already fighting, do not allow the dialog to restart
	if is_in_combat:
		print("DEBUG: Interaction blocked - NPC is already in combat.")
		return

	# --- ORIGINAL CODE (Turned into comments) ---
	# # Pass 'self' so the manager can look at our entity_name
	# DialogManager.start_dialog(dialog_resource, self)
	# if is_hostile:
	# 	CombatManager.start_combat(get_tree().get_first_node_in_group("Player"), self)
	# else:
	# 	DialogManager.start_dialog(dialog_resource, self)

	# --- NEW UPDATED LOGIC ---
	
	# Capture the player node once during the interaction event
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		player = get_tree().root.find_child("Player", true, false)
	
	if is_hostile:
		# Set flag to prevent dialog re-triggering
		is_in_combat = true
		CombatManager.start_combat(player, self)
	else:
		# For aggressive dialogs that trigger combat via UI
		if not ("player_options" in dialog_resource):
			is_in_combat = true
			
		DialogManager.setup_dialog(dialog_resource, self, player)
