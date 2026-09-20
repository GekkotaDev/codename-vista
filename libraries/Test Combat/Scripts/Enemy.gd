extends CharacterBody3D

@export var data: EnemyData # Assign EnemyData.tres here


func _ready():
	# Register with global manager using unique name
	if data:
		HealthManager.register_entity(data)


# for detection
func _on_detection_range_body_entered(body):
	print("DEBUG: Something touched the detection range: ", body.name)

	if body.name == "Player":
		print("Player is in range")
		CombatManager.start_combat(body, self)
	else:
		print("Object detected was not the player")


# Death Function
func die():
	print(data.name, " has been defeated!")
	queue_free()
