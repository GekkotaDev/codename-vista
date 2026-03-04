extends CharacterBody3D

@export var data: PlayerData # Assign PlayerData.tres here
@onready var interaction_volume = $InteractionVolume # The new Area3D for detecing scenes Player can interact with

func _ready():
	if data:
		HealthManager.register_entity(data)

func _input(event):
	# Check for the interact key
	if event.is_action_pressed("player_interact"):
		check_interactions()

func check_interactions():
	# Get all bodies currently inside our 'bubble'
	var bodies = interaction_volume.get_overlapping_bodies()
	
	for body in bodies:
		# If the body has an 'interact' function, call it!
		if body.has_method("interact"):
			print("Player: Interacting with ", body.name)
			body.interact()
			break # Stop after interacting with the first thing found

func _physics_process(delta: float) -> void:
	if not data: return
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = data.jump_velocity

	var input_dir := Input.get_vector("player_left", "player_right", "player_up", "player_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * data.speed
		velocity.z = direction.z * data.speed
	else:
		velocity.x = move_toward(velocity.x, 0, data.speed)
		velocity.z = move_toward(velocity.z, 0, data.speed)
		
	move_and_slide()
