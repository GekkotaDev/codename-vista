class_name T

@export var count: int:
	get:
		return T.of_nullable(TYPE_INT, count)
	set(value):
		count = T.of(TYPE_INT, count)


##
static func noop() -> void:
	pass


##
static func of(type: Variant.Type, value: Variant) -> Variant:
	var expected := type
	var received := typeof(value)
	var message := "Expected value of type <{expected}> but instead received type <{received}>" \
	.format(
		{
			"expected": expected,
			"received": received,
		},
	)

	assert(is_instance_of(value, type), message)
	return value


##
static func of_nullable(type: Variant.Type, value: Variant) -> Variant:
	if value == null:
		return value
	return of(type, value)


func _init() -> void:
	var message := "T is not instantiable."
	assert(false, message)
