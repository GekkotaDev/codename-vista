## An opinionated character controller setup.
class_name CharacterBodyMovementController3D
extends CharacterBody3D

@export var sources: Array[InputSource3D]
@export var input_subscribers: Array[InputSubscriber3D]


##
func poll_input() -> InputSource3D:
	var index := sources.find_custom(
		func(publisher: InputSource3D):
			return publisher.active,
	)
	var input := sources[index]

	input.poll()

	return input


##
func poll_event(delta: float, publisher: InputSource3D = null) -> InputSubscriber3D.Event:
	if not publisher:
		publisher = poll_input()
	var event := InputSubscriber3D.Event.new()

	event.body = self
	event.delta = delta
	event.source = publisher

	return event


##
func process_input(delta: float) -> void:
	var event := poll_event(delta)
	for subscriber in input_subscribers:
		subscriber.mutate_input(event)
