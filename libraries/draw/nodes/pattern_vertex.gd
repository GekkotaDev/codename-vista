## Individual vertex within a pattern grid. [br]
## 
## [PatternVertex] nodes should only be used within [PatternGrid] nodes. These
## represent points within the pattern drawing, notifying their parent grid of
## the input events that the player has so far given to them. [br]
##
## @experimental 
class_name PatternVertex
extends Control

signal selected(vertex: PatternVertex)

@export var model: PatternVertexModel
