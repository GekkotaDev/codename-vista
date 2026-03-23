##
@abstract
class_name SaveFile
extends Resource

const _SAVE_FLAGS = (
	ResourceSaver.FLAG_BUNDLE_RESOURCES +
	ResourceSaver.FLAG_COMPRESS
)

signal saved

@export var id: String

@export_group("Version")
## Major version.
## [br]
## A change in the major version indicates that a set of breaking changes is to
## be expected.
@export var version: int = 0

## Patch version.
## [br]
## This indicates non-breaking changes* to the save file format and may be used
## by external save editor tools.
@export var patch: int = 0


## A unique value computed from the resource used to verify the integrity of
## the data.
@abstract func checksum() -> PackedByteArray


## Downgrade this save file to the previous version.
## [br]
## This is not used under normal circumstances beyond as a last resort measure
## when the data can't be loaded.
@abstract func downgrade() -> SaveFile


var _directory := "user://saves/v{version}/files".format({ version = version })
var _target := "{directory}/{id}.res".format(
	{
		directory = _directory,
		id = id,
	},
)


## Generate a checksum from the provided resource.
static func generate_checksum(resource: Resource) -> PackedByteArray:
	const _USAGE_FLAGS = (
		PROPERTY_USAGE_STORAGE +
		PROPERTY_USAGE_EDITOR +
		PROPERTY_USAGE_SCRIPT_VARIABLE
	)

	return JSON.stringify(
		resource.get_property_list() \
		.filter(func(property): return property["usage"] == _USAGE_FLAGS) \
		.map(
			func(property):
				var resource_property = resource[property["name"]]

				if resource_property is PersistedResource:
					return resource_property.checksum
				return resource_property,
		),
	).sha256_buffer()


func invalidate() -> SaveFile:
	version = -1
	return self


## Save the current progress.
## [br]
## The current scene tree is required to call all [SavePersistenceClient]s. In
## addition, a signal is emitted to inform all subscribers to the save file.
func persist(scene_tree: SceneTree) -> SaveFile:
	scene_tree.call_group(SavePersistenceClient.GROUP_NAME, "save", self)

	ResourceSaver.save(self, _target, _SAVE_FLAGS)
	saved.emit()

	return self
