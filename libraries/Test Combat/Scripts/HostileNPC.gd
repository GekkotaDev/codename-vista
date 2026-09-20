# No class_name needed here since it's loaded dynamically
extends CharacterBody3D

@export var is_hostile: bool = true
@export var dialog_resource: HomelessDialogData
@export var data: Resource 
@export var entity_name: String = "" 

# --- NEW LOGIC VARIABLE ---
var is_in_combat: bool = true

func _ready():
	# --- ORIGINAL CODE (Turned into comments) ---
	# # Register for combat
	# if data:
	# 	HealthManager.register_entity(data)

	# --- NEW CODE ---
	if data:
		HealthManager.register_entity(data)
		
		if data.has_signal("health_changed"):
			data.connect("health_changed", _on_local_health_changed)
	
	# --- NEW UPDATED LOGIC (The "Nuclear" Hook) ---
	# We connect to the CombatManager's end signal. 
	# If combat ends and we are at 0 HP, we MUST vanish.
	if CombatManager.has_signal("combat_finished"):
		CombatManager.connect("combat_finished", _on_combat_finished)
		
	if HealthManager.has_signal("entity_died"):
		HealthManager.connect("entity_died", _on_health_manager_entity_died)
	
	var area = get_node_or_null("DetectionRange")
	if area and not area.body_entered.is_connected(_on_detection_range_body_entered):
		area.body_entered.connect(_on_detection_range_body_entered)

# --- NEW ULTIMATE FAIL-SAFE (Polling) ---
func _process(_delta):
	if is_in_combat and data:
		var current_hp = 100
		
		# Check all possible variations of the health variable name
		if "current_health" in data: current_hp = data.current_health
		elif "health" in data: current_hp = data.health
		elif "hp" in data: current_hp = data.hp
		
		if current_hp <= 0:
			# --- ORIGINAL CODE (Turned into comments) ---
			# die()
			
			print("DEBUG: _process detected 0 HP. Forcing die().")
			is_in_combat = false 
			die()

# --- NEW COMBAT END CHECK ---
func _on_combat_finished():
	# Wait one frame for HealthManager to finish its update
	await get_tree().process_frame
	
	# If combat is over, we check health via HealthManager directly as a backup
	var final_hp = HealthManager.get_hp(entity_name)
	if final_hp <= 0:
		print("DEBUG: Combat finished signal confirms 0 HP via HealthManager.")
		die()

# --- NEW LOCAL MONITOR HANDLER ---
func _on_local_health_changed(_new_hp):
	if data:
		var hp_val = 100
		if "current_health" in data: hp_val = data.current_health
		elif "health" in data: hp_val = data.health
		
		if hp_val <= 0:
			die()

# --- NEW SIGNAL HANDLER ---
func _on_health_manager_entity_died(dead_data):
	if dead_data == self.data:
		die()

func _on_detection_range_body_entered(body):
	if body.name == "Player":
		print("Player is in range")
		CombatManager.start_combat(body, self)
	else:
		print("Object detected was not the player")

func die():
	# --- ORIGINAL CODE (Turned into comments) ---
	# print(data.name, " defeated!")

	# --- NEW UPDATED LOGIC ---
	var d_name = "Unknown NPC"
	if data and data.has_method("get"):
		var val = data.get("name")
		if val != null:
			d_name = val
	
	print(d_name, " defeated!")

	# --- LEAK PREVENTION: UNREGISTER FROM MANAGERS ---
	if data and HealthManager.has_method("unregister_entity"):
		HealthManager.unregister_entity(data)
	
	if dialog_resource and DialogManager.has_method("clear_dialog_ref"):
		DialogManager.clear_dialog_ref(dialog_resource)

	# --- FINAL FORCED REMOVAL ---
	# We use call_deferred to ensure the node is removed safely 
	# even if this was called inside a physics/signal callback.
	print("DEBUG: Finalizing queue_free for ", self.name)
	
	# --- ORIGINAL CODE (Turned into comments) ---
	# data = null
	# dialog_resource = null
	# queue_free()
	
	data = null
	dialog_resource = null
	self.queue_free()
