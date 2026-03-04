## Individual vertex within a pattern grid. [br]
##
## [PatternVertex] nodes should only be used within [PatternGrid] nodes. These
## represent points within the pattern drawing, notifying their parent grid of
## the input events that the player has so far given to them. [br]
##
## @experimental
class_name PatternVertex
extends Control

@export var model: PatternVertexModel


func _ready() -> void:
	add_child(model.timer)

	mouse_entered.connect(func(): model.selected.emit())
