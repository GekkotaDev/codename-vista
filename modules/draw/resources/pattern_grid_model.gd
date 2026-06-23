##
class_name PatternGridModel
extends Resource

@export var vertices: Array[PatternGridRow] = []

@export_group("Dimensions")
@export var height: int
@export var length: int

var target: PatternVertexModel

var models: Array[PatternVertexModel]:
	get:
		return vertices \
		.map(func(row: PatternGridRow): return row.vertices) \
		.reduce(
			func(vertex_models: Array[PatternVertexModel], slice: Array[PatternVertexModel]):
				var result := vertex_models.duplicate()
				result.append_array(slice)
				return result
		)


func _init() -> void:
	validate_properties()


func validate_properties():
	# Validate the size of the grid.
	assert(vertices.size() == height)
	vertices.map(func(row: PatternGridRow): assert(row.vertices.size() == length))


func is_looped():
	return models.all(
		func(model: PatternVertexModel):
			return (
				(model.status == PatternStates.VertexState.CLOSED) or
				(model.status == PatternStates.VertexState.EMPTY)
			)
	)
