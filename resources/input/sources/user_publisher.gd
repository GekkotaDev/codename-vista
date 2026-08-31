class_name InputSourceUser3D
extends InputSource3D


func poll() -> void:
	self.direction = Input.get_vector(&"player_left", &"player_right", &"player_up", &"player_down")
	self.jumped = Input.is_action_just_pressed(&"player_jump")
