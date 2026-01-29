class_name SceneLoaderTarget
extends Resource

signal progress(path: String, progress: float)
signal completed(path: String)

var poll_progress: float = -1.0
var poll_state: ResourceLoader.ThreadLoadStatus = ResourceLoader.THREAD_LOAD_INVALID_RESOURCE

@export var name: String = ""
@export_file("*.tscn") var path: String


func load():
	if poll_progress < 0.0:
		poll_progress = 0.0

	ResourceLoader.load_threaded_request(path)


func query_status() -> ResourceLoader.ThreadLoadStatus:
	if poll_progress < 0.0:
		return poll_state

	var progress_ratio := []
	var status := ResourceLoader.load_threaded_get_status(path, progress_ratio)

	poll_state = status
	poll_progress = progress_ratio[0]
	progress.emit(path, poll_progress)

	if poll_progress >= 1.0:
		poll_progress = -1.0
		completed.emit(path)

		return poll_state

	return poll_state
