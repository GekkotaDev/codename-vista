extends SceneView

const Model = preload("./ui_model.gd")

@export var model: Model


func _script(_events: EventBus):
	resource_model = model


func _view():
	pass
