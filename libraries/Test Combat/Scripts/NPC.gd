@tool # This allows the script to run in the Editor/Inspector
extends CharacterBody3D

@export var is_hostile: bool = false

@export var dialog_resource: Resource:
	set(val):
		if Engine.is_editor_hint() and val != null:
			dialog_resource = val.duplicate(true)
		else:
			dialog_resource = val

@export var data: Resource: # Holds Health/Stats
	set(val):
		if Engine.is_editor_hint() and val != null:
			data = val.duplicate(true)
		else:
			data = val

@export var entity_name: String = "Homeless Person" # Change this in Inspector for different NPCs

# --- NEW LOGIC VARIABLE ---
var is_in_combat: bool = false

func _ready():
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
			# --- NEW UPDATED LOGIC ---
			self.set("is_in_combat", true)
			
			if has_method("_ready"):
				_ready()
		else:
			set_process(false)

func _on_global_death_check(dead_data_ref):
	if dead_data_ref == self.data:
		if dialog_resource:
			DialogManager.clear_dialog_ref(dialog_resource)
		queue_free()

func interact():
	# --- NEW UPDATED LOGIC (Interaction Guard) ---
	# This prevents the dialogue from popping up if combat is already flagged
	if is_in_combat:
		print("DEBUG: Interaction blocked - NPC is locked for combat.")
		return

	# Capture the player node once during the interaction event
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		player = get_tree().root.find_child("Player", true, false)
	
	if is_hostile:
		# --- NEW UPDATED LOGIC ---
		is_in_combat = true
		CombatManager.start_combat(player, self)
	else:
		# --- NEW UPDATED LOGIC ---
		# If we detect Crazy data, we mark this NPC as "in combat" immediately
		# so the player can't spam E while the UI is open.
		if dialog_resource is CrazyHomelessDialogData:
			is_in_combat = true
			
		DialogManager.setup_dialog(dialog_resource, self, player)
