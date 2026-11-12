extends Camera3D

@export var target: Node3D
@export var offset: Vector3 = Vector3(0, 3, -12)
@export var follow_speed: float = 5.0

func _physics_process(delta: float) -> void:
	if target == null:
		return
	
	# Smoothly move camera toward target + offset
	var desired_position = target.global_position + offset
	global_position = global_position.lerp(desired_position, follow_speed * delta)
	
	# Keep camera facing the player
	look_at(target.global_position, Vector3.UP)
