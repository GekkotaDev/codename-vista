extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var data: PlayerData # Assign PlayerData.tres here

func _ready():
	# Register with global healthmanager
	if data:
		HealthManager.register_entity(data)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# for complete 3D movement
	var input_dir := Input.get_vector("player_left", "player_right", "player_up", "player_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()
