extends SceneView

@export var nodes: Dictionary[StringName, Control] = { }

const Model = preload("./ui_model.gd")


func _script(_events: EventBus):
	pass


func _view(model: ResourceModel):
	model = model as Model
