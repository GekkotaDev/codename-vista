extends CharacterBody3D


@export var max_health: int = 50

func _ready():
	# Register with global manager using unique name ---
	HealthManager.register_entity(self.name, max_health)

# for detection
func _on_detection_range_body_entered(body):
	# for debugging to see if detection works
	print("DEBUG: Something touched the detection range: ", body.name)
	
	# Check if it's the Player
	if body.name == "Player":
		print("Player is in range")
		
		# 3. Tell the CombatManager to start the fight
		# We pass 'body' (the player) and 'self' (this enemy)
		CombatManager.start_combat(body, self)
	else:
		print("Object detected was not the player")

# --- NEW: Death Function ---
func die():
	print(self.name, " has been defeated!")
	queue_free() # Remove enemy from scene
# Note: You can delete the empty _on_area_3d functions 
# unless you specifically need multiple detection zones.
