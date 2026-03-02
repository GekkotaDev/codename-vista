## Individual vertex within a pattern grid. [br]
## 
## [PatternVertex] nodes should only be used within [PatternGrid] nodes. These
## represent points within the pattern drawing, notifying their parent grid of
## the input events that the player has so far given to them. [br]
##
## @experimental 
class_name PatternVertex
extends Control

signal selected

@export var model: PatternVertexModel

var timer := Timer.new()


func _ready() -> void:
	timer.wait_time = model.timeout

	add_child(timer)
