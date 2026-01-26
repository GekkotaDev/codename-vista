extends SceneView

const Model = preload("./ui_model.gd")

@export var router: RouterNode

@export_group("Scenes")
@export var loading_screen: SceneLoaderTarget


func _script(events: EventBus, _model: ResourceModel):
	events.connect_of(
		"play_button",
		&"pressed",
		func():
			router.goto("play")
	)

	events.connect_of(
		"settings_button",
		&"pressed",
		func():
			router.goto("test")
	)

	events.connect_of(
		"quit_button",
		&"pressed",
		func():
			get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
			get_tree().quit()
	)
