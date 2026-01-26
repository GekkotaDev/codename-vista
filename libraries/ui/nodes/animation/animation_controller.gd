class_name AnimationController
extends Node

signal animation_begun
signal animation_ended

@export var animations: Array[ProtonControlAnimation] = []


func sum_duration(node: ProtonControlAnimation) -> float:
	if node.stop_trigger_source is ProtonControlAnimation:
		return sum_duration(node.stop_trigger_source) + node.duration

	if node.start_trigger_source is ProtonControlAnimation:
		return sum_duration(node.start_trigger_source) + node.duration

	return node.duration


func start(advance: float = 0.0):
	var duration: float = animations \
	.map(
		func(node: ProtonControlAnimation) -> float:
			return sum_duration(node),
	) \
	.reduce(
		func(accumulator: float, selected: float) -> float:
			return accumulator if selected < accumulator else selected
	) - advance

	animation_begun.emit()

	for animation in animations:
		animation.start()

	Timeout.of(self).do(
		func():
			animation_ended.emit()
	).once(duration)
