extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 8
@export var gravity: float = 15
@onready var sprite: Sprite3D = $Sprite3D
@export var fall_multiplier: float = 2.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y -= gravity * fall_multiplier * delta
		else:
			velocity.y -= gravity * delta

	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("player_left", "player_right", "player_up", "player_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if Input.is_action_pressed("player_left"):
		sprite.flip_h = true
	elif Input.is_action_pressed("player_right"):
		sprite.flip_h = false
	
	move_and_slide()
