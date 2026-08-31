extends CharacterBodyMovementController3D

@export var speed := 5.0
@export var jump_velocity := 4.5


func _physics_process(delta: float) -> void:
	var event := poll_event(delta)
	var input := event.source

	for subscriber in input_subscribers:
		subscriber.mutate_input(event)

	if not is_on_floor():
		velocity += get_gravity() * delta

	if input.jumped and is_on_floor():
		velocity.y = jump_velocity

	var direction := (
		#
		transform.basis * Vector3(input.direction.x, 0, input.direction.y)
	).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
