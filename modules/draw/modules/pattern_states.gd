class_name PatternStates

enum VertexState {
	## Vertex should be ignored.
	EMPTY,

	## Vertex had already been traversed.
	CLOSED,

	## Vertex has not yet been traversed.
	OPEN,
}

enum VertexResponse {
	IGNORE,
	FAIL,
	PASS,
}

enum GridError {
	LOOP,
	UNKNOWN,
	GENERAL,
}
