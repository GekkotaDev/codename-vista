class_name PatternVertexModel
extends Resource

signal selected

@export var status := PatternStates.VertexState.OPEN
@export var timeout: float
@export var siblings: Array[PatternVertexModel]

var timer := Timer.new()


func _bubble():
	return [selected]


## Ensure that the provided vertex is a valid target to be traversed to. [br]
##
## It is [OK] if it's a valid target, otherwise [ERR_SKIP] is returned if it
## can be safely ignored or [ERR_INVALID_DATA] if it was incorrect to travel
## into it. Callers must handle the errors accordingly to what is deemed to be
## the right behavior for such cases.
func validate_vertex(model: PatternVertexModel) -> Error:
	if model.status == PatternStates.VertexState.EMPTY:
		return ERR_SKIP

	if model not in siblings:
		return ERR_INVALID_DATA

	if model.status == PatternStates.VertexState.CLOSED:
		return ERR_CANT_CONNECT

	return OK
