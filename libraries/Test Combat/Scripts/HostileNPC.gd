# No class_name needed here since it's loaded dynamically
extends CharacterBody3D

@export var is_hostile: bool = true
@export var dialog_resource: HomelessDialogData
@export var data: Resource 
@export var entity_name: String = "" 

func _ready():
	# --- ORIGINAL CODE (Turned into comments) ---
	# # Register for combat
	# if data:
	# 	HealthManager.register_entity(data)

	# --- NEW CODE ---
	if data:
		HealthManager.register_entity(data)
	
	# Connect the detection signal manually since we swapped scripts
	var area = get_node_or_null("DetectionRange")
	if area and not area.body_entered.is_connected(_on_detection_range_body_entered):
		area.body_entered.connect(_on_detection_range_body_entered)

func _on_detection_range_body_entered(body):
	if body.name == "Player":
		print("Player is in range")
		CombatManager.start_combat(body, self)
	else:
		print("Object detected was not the player")

func die():
	# --- ORIGINAL CODE (Turned into comments) ---
	# print(data.name, " defeated!")

	# --- NEW UPDATED LOGIC (Safe Get & Cleanup) ---
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

	# Explicitly nullify to drop Reference Count to 0
	data = null
	dialog_resource = null
	
	queue_free()
