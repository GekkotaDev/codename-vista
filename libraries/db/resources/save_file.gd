##
@abstract
class_name SaveFile
extends Resource

const _SAVE_FLAGS = (
	ResourceSaver.FLAG_BUNDLE_RESOURCES +
	ResourceSaver.FLAG_COMPRESS
)

@export var id: String

@export_group("Version")
##
@export var version: int = 0

##
@export var patch: int = 0


##
@abstract func checksum() -> PackedByteArray


##
@abstract func migrate(storage: SaveFile) -> SaveFile


##
@abstract func downgrade() -> SaveFile


var _directory = "user://saves/v{version}/files".format({ version = version })


static func serialize_checksum(resource: Resource) -> PackedByteArray:
	const _USAGE_FLAGS = (
		PROPERTY_USAGE_STORAGE +
		PROPERTY_USAGE_EDITOR +
		PROPERTY_USAGE_SCRIPT_VARIABLE
	)

	return JSON.stringify(
		resource.get_property_list() \
		.filter(func(property): return property["usage"] == _USAGE_FLAGS) \
		.map(func(property): return resource[property["name"]]),
	).sha256_buffer()


func invalidate() -> SaveFile:
	version = -1
	return self


func save():
	var target := "{directory}/{id}.res".format(
		{
			directory = _directory,
			id = id,
		},
	)

	ResourceSaver.save(self, target, _SAVE_FLAGS)
