extends AnimatableBody3D

@export var distance: float = 5.0  # Meters (3D uses meters, not pixels)
@export var duration: float = 3.0

func _ready():
	var tween = create_tween().set_loops().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	# Move along the X axis
	tween.tween_property(self, "position:x", position.x + distance, duration).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:x", position.x, duration).set_trans(Tween.TRANS_SINE)
