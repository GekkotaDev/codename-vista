class_name Timeout

var _duration := -1.0
var _timer := Timer.new()


static func of(node: Node):
	var timeout := Timeout.new(true)

	#! 3rd paty tool GDScript Formatter complains this is external access of
	#! private variables.
	node.add_child(timeout.get("_timer"))
	return timeout


func _init(USE_TIMEOUT_DOT_OF: bool = false) -> void:
	var message := (
		"Timeout should not be directly instantiated. Please use Timeout.of(node) instead"
	)
	assert(USE_TIMEOUT_DOT_OF, message)


@warning_ignore("int_as_enum_without_match")
func do(callback: Callable, flags: ConnectFlags = 0 as ConnectFlags):
	_timer.timeout.connect(callback, flags)
	return self


func every(seconds: float):
	_duration = seconds
	return self


func once(seconds: float = -1) -> void:
	var duration := seconds if seconds >= 0 else _duration
	_timer.one_shot = true
	_timer.timeout.connect(
		func():
			_timer.queue_free(),
		ConnectFlags.CONNECT_ONE_SHOT,
	)
	_timer.start(duration)


func interval(seconds: float = -1) -> void:
	var duration := seconds if seconds >= 0 else _duration
	_timer.one_shot = false
	_timer.start(duration)
