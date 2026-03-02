## Grid containing a drawing pattern. [br]
##
## [PaternGrid]s manage their [PatternVertex] child nodes by responding acocrdingly
## to their signals with appropriate behaviors, and to ensure that they're all
## ordered accordingly to the correct grid layout. [br]
## 
## @experimental
class_name PatternGrid
extends GridContainer

signal success
signal failed

@export var model: PatternGridModel

var vertex_models: Array[PatternVertexModel]:
	get:
		return model.vertices \
		.map(func(row: PatternGridRow): return row.vertices) \
		.reduce(
			func(models: Array[PatternVertexModel], slice: Array[PatternVertexModel]):
				var result := models.duplicate()
				result.append_array(slice)
				return result
		)

var vertices: Array[PatternVertex]:
	get:
		return get_children().filter(
			func(node): return node is PatternVertex
		)


func _ready() -> void:
	rerender_vertices()


func when_target_available(callback: Callable, fallback: Callable = func(..._0): pass):
	return func(...parameters):
		if model.target:
			return callback.callv(parameters)
		fallback.callv(parameters)


func on_selected(vertex: PatternVertex):
	vertex.selected.connect(
		func():
			vertex.timer.start()

			if model.target == null:
				model.target = vertex.model
				return

			var result := vertex.model.validate_vertex(model.target)
			match result:
				ERR_SKIP:
					pass
				ERR_INVALID_DATA:
					failed.emit(PatternStates.GridError.UNKNOWN)
				ERR_CANT_CONNECT:
					failed.emit(PatternStates.GridError.LOOP)
				OK:
					model.target = vertex.model
					vertex_models.all(
						func(vertex_model: PatternVertexModel):
							return (
								vertex_model.status == PatternStates.VertexState.CLOSED or
								vertex_model.status == PatternStates.VertexState.EMPTY
							)
					)
				_:
					assert(
						false,
						"Unhandled error: {error}".format(
							{
								error = error_string(result),
							},
						),
					)
	)


func observe_vertices():
	vertices.map(on_selected)


## Re-render all the child vertices of the grid. [br]
##
## The vertices that will be rendered shall depend on the [member model]s that
## is associated with the grid. It should be noted that all and only all child
## nodes of type [Patternvertex] will be removed in the process. [br]
##
## Any and all nodes that are not [PatternVertex] nodes will not be affected.
## Their ordering in the scene tree however may be affected particularly if they
## exist at the end of their parent's array of children.
func rerender_vertices():
	columns = model.length

	vertices.map(
		func(child):
			remove_child(child)
			child.queue_free()
	)

	vertex_models.map(
		func(vertex_model: PatternVertexModel):
			var vertex := PatternVertex.new()

			vertex.model = vertex_model

			add_child(vertex)
	)

	observe_vertices()
