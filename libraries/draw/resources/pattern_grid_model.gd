##
class_name PatternGridModel
extends Resource

@export var vertices: Array[PatternGridRow] = []

@export_group("Dimensions")
@export var height: int
@export var length: int

var target: PatternVertexModel


func _init() -> void:
	validate_properties()


func validate_properties():
	# Validate the size of the grid.
	assert(vertices.size() == height)
	vertices.map(func(row: PatternGridRow): assert(row.vertices.size() == length))
