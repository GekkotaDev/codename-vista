extends CharacterBody3D


@export var is_hostile: bool = false
@export var dialog_resource: HomelessDialogData
@export var data: Resource # Holds Health/Stats
@export var entity_name: String = "Homeless Person" # Change this in Inspector for different NPCs

func _ready():
	if data:
		HealthManager.register_entity(data)
	
	if is_hostile:
		
		# NEW: Swap to the HostileNPC script to keep code clean
		var saved_data = data # Save data before swap
		var hostile_script = load("res://libraries/Test Combat/Scripts/HostileNPC.gd")
		set_script(hostile_script)
		
		# Re-assign data and trigger the new _ready() because
		self.data = saved_data
		if has_method("_ready"):
			_ready()
	else:
		set_process(false)

func interact():
	# Pass 'self' so the manager can look at our entity_name
	DialogManager.start_dialog(dialog_resource, self)
	if is_hostile:
		# This part is usually handled by HostileNPC after the swap, 
		# but we keep it here as a fallback.
		CombatManager.start_combat(get_tree().get_first_node_in_group("Player"), self)
	else:
		# Open the Dialog UI
		DialogManager.start_dialog(dialog_resource, self)
