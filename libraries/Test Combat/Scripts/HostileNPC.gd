# No class_name needed here since it's loaded dynamically
extends CharacterBody3D

# Will be passed from the NPC script
var data: Resource 

func _ready():
	# Register for combat
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
	print(data.name, " defeated!")
	queue_free()
