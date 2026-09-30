extends Camera3D

@export var target: Node3D
@export var offset: Vector3 = Vector3(0, 3, 6)
@export var follow_speed: float = 5.0

@export var min_x: float = -10.0
@export var max_x: float = 10.0

var fixed_y: float
var fixed_z: float

func _ready() -> void:
	fixed_y = global_position.y
	fixed_z = global_position.z

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("dialogic_default_action"):
		print(global_position)
	
	var desired_x = target.global_position.x + offset.x
	desired_x = clamp(desired_x, -10.37804, max_x)
	
	var desired_position = Vector3(desired_x, fixed_y, fixed_z)
	global_position = global_position.lerp(desired_position, follow_speed * delta)
