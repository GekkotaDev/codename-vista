extends Control

@export var routes: Dictionary[StringName, Control] = {}

var route := S.string("")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	S.declare([
		S.effect(
			func():
				var control := routes[route.value]
				
				for key in routes:
					routes[key].visible = false
				
				if control == null:
					return
					
				control.visible = true,
		)
	]).bind(self)
