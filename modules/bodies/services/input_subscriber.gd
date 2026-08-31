@abstract
class_name InputSubscriber3D
extends Resource


class Event:
	var body: PhysicsBody3D
	var delta: float
	var source: InputSource3D


@abstract func mutate_input(event: Event) -> void
