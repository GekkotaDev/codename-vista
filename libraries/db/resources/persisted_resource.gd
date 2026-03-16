##
class_name PersistedResource
extends Resource

const _USAGE_FLAGS = (
	PROPERTY_USAGE_STORAGE +
	PROPERTY_USAGE_EDITOR +
	PROPERTY_USAGE_SCRIPT_VARIABLE
)

##
@export var id: String

var checksum: PackedByteArray:
	get:
		return JSON.stringify(
			get_property_list() \
			.filter(func(property): return property["usage"] == _USAGE_FLAGS) \
			.map(func(property): return self[property["name"]]) \
			.map(
				func(property: Variant):
					if property is PersistedResource:
						return property.checksum
					return property,
			),
		).sha256_buffer()
	set(_value):
		pass
