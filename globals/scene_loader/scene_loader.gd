class_name SceneLoaderHooks
extends Node

@export var cached: Dictionary[String, PackedScene] = { }

var queue: Array[Target]
var target: SceneLoaderTarget


class Target:
	var callback: Callable
	var target: SceneLoaderTarget

##
signal status(state: ResourceLoader.ThreadLoadStatus)


func _process(_delta: float) -> void:
	if target == null and queue.size() > 0:
		pop_load()

	if target == null:
		return

	var state := target.query_status()
	match state:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS, ResourceLoader.THREAD_LOAD_LOADED:
			pass
		ResourceLoader.THREAD_LOAD_FAILED:
			target = null
			status.emit(target.poll_state)


##
func cache_scene(id: String, scene: PackedScene):
	if id == "":
		return self
	cached[id] = scene
	return self


##
func from_cache(target_name: String, callback: Callable):
	var scene := cached[target_name]
	if scene != null:
		callback.call(scene)
		status.emit(ResourceLoader.THREAD_LOAD_LOADED)
		target = null
	return self


##
func enqueue(spec: SceneLoaderTarget, callback: Callable):
	if spec.name in cached:
		var scene := cached[spec.name]
		callback.call(scene)
		return self

	var queue_item := Target.new()

	queue_item.target = spec
	queue_item.callback = callback
	queue.push_back(queue_item)

	return self


##
func pop_load():
	var item: Target = queue.pop_back()

	if item == null:
		return self

	target = item.target
	item.target.load()
	item.target.completed.connect(
		func(path: String):
			item.callback.call(ResourceLoader.load_threaded_get(path))
			status.emit(ResourceLoader.THREAD_LOAD_LOADED)
			target = null,
		ConnectFlags.CONNECT_ONE_SHOT,
	)

	return self


##
func warmup_target(spec: SceneLoaderTarget):
	spec.load()
	return self
