extends CharacterBody3D

@export var is_hostile: bool = false
@export var dialog_resource: HomelessDialogData
@export var data: Resource # Holds Health/Stats
@export var entity_name: String = "Homeless Person" # Change this in Inspector for different NPCs

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
	
	# Duplicate Dialog so each NPC instance has its own unique text/options
	if dialog_resource:
		dialog_resource = DuplicateManager.get_duplicate_resource(dialog_resource)

	if data:
		# Duplicate the stats/health resource
		data = DuplicateManager.get_duplicate_resource(data)
		
		if data.has_method("set"):
			data.set("name", self.entity_name)
			# Ensure the name is applied to the unique instance
			data = DuplicateManager.get_duplicate_resource(data)
			
			var unique_name = data.get("name")
			if unique_name:
				self.entity_name = unique_name
			
		HealthManager.register_entity(data)
	
	if is_hostile:
		var saved_data = data 
		var saved_name = self.entity_name
		var saved_dialog = dialog_resource
		
		var hostile_script = load("res://libraries/Test Combat/Scripts/HostileNPC.gd")
		set_script(hostile_script)
		
		# Re-apply properties so the new script instance is functional
		self.set("data", saved_data)
		self.set("entity_name", saved_name)
		self.set("dialog_resource", saved_dialog)
		
		if has_method("_ready"):
			_ready()
	else:
		set_process(false)

func interact():
	# --- ORIGINAL CODE (Turned into comments) ---
	# # Pass 'self' so the manager can look at our entity_name
	# DialogManager.start_dialog(dialog_resource, self)
	# if is_hostile:
	# 	# This part is usually handled by HostileNPC after the swap, 
	# 	# but we keep it here as a fallback.
	# 	CombatManager.start_combat(get_tree().get_first_node_in_group("Player"), self)
	# else:
	# 	# Open the Dialog UI
	# 	DialogManager.start_dialog(dialog_resource, self)

	# --- NEW UPDATED LOGIC ---
	if is_hostile:
		CombatManager.start_combat(get_tree().get_first_node_in_group("Player"), self)
	else:
		DialogManager.start_dialog(dialog_resource, self)
