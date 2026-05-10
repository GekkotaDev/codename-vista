extends Control

@export var target_scene: SceneLoaderTarget
@export_file("*.dtl") var dialog_path: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneLoader.warmup_target(target_scene)
	
	Dialogic.start(dialog_path)
	Dialogic.timeline_ended.connect(
		func():
			SceneLoader.enqueue(
				target_scene,
				func(path):
					SceneManager.change_scene(path)
			),
		CONNECT_ONE_SHOT
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
