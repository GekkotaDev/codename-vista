## Grid containing a drawing pattern. [br]
##
## [PaternGrid]s manage their [PatternVertex] child nodes by responding acocrdingly
## to their signals with appropriate behaviors, and to ensure that they're all
## ordered accordingly to the correct grid layout. [br]
## 
## @experimental
class_name PatternGrid
extends GridContainer

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


func _ready() -> void:
	rerender_vertices()


func observe_vertices():
	var vertices: Array[PatternVertex] = get_children().filter(
		func(node): return node is PatternVertex
	)

	vertices.map(
		func(vertex: PatternVertex):
			pass
	)


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

	get_children().map(
		func(child):
			if child is PatternVertex:
				remove_child(child)
				child.queue_free()
	)

	vertex_models.map(
		func(vertex_model: PatternVertexModel):
			var vertex := PatternVertex.new()

			vertex.model = vertex_model

			add_child(vertex)
	)
