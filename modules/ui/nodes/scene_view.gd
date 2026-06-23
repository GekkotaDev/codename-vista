@abstract class_name SceneView
extends Control

@export var nodes: Dictionary[String, Control]
@export var resource_model: ResourceModel

var _event_bus := EventBus.new()


##
func _view(_model: ResourceModel):
	pass


##
func _script(_events: EventBus, _model: ResourceModel):
	pass


##
func _predelete():
	pass


##
func _preready():
	pass


##
func _postready():
	pass


##
func _update():
	pass


func _ready() -> void:
	_event_bus.nodes = nodes

	_preready()
	_script(_event_bus, resource_model)
	_view(resource_model)
	_postready()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			_predelete()


##
func set_state(setter: Callable):
	_update()

	if resource_model == null:
		return

	resource_model.set_state(setter)


##
func effect(properties: Array[String], callback: Callable) -> Callable:
	callback.call()

	if resource_model == null:
		return callback

	resource_model.subscribe(
		func(diff: Dictionary[StringName, Variant]):
			for property in properties:
				if property in diff:
					callback.call()
					return
	)

	return callback


##
func each_controls(parent: Control, builder: Callable):
	var new_children: Array[Control] = builder.call()
	if not (new_children is Array[Control]):
		return

	var current_children := parent.get_children()

	for child in current_children:
		parent.remove_child(child)

	for child in new_children:
		parent.add_child(child)


##
func show_control(parent: Control, child: Control, conditional: Callable):
	var condition: Variant = conditional.call()

	# Clarity is better than conciseness. See Mathematical notation when conciseness
	# is prioritized over clarity.
	if condition == true and not parent.find_child(child.name):
		parent.add_child(child)
		return

	if parent.find_child(child.name):
		parent.remove_child(child)
