class_name SaveFileV0
extends SaveFile

const TARGET_FOLDER = "user://saves/v0"

@export var collections: Collections


class Collections extends Resource:
	var player: PersistedV0Player


static func load(path: String) -> SaveFileV0:
	var file := ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE_DEEP)
	assert(file is SaveFileV0)
	return file


func checksum() -> String:
	return ""


func migrate(storage: SaveFile) -> Error:
	return OK


func downgrade() -> SaveFile:
	return self


func save():
	var target := "{folder}/{id}".format(
		{
			folder = TARGET_FOLDER,
			id = self.id,
		},
	)

	ResourceSaver.save(self, target, ResourceSaver.FLAG_BUNDLE_RESOURCES)
