class_name SaveRepository
extends Node

const _SAVE_FLAGS = (
	ResourceSaver.FLAG_BUNDLE_RESOURCES +
	ResourceSaver.FLAG_COMPRESS
)

@export var version: int

var checksums: Dictionary[String, PackedByteArray] = { }
var saves: Dictionary[String, SaveFile] = { }

var hash_path := "user://saves/v{version}/hash.bin".format({ version = version })
var files_path := "user://saves/v{version}/files".format({ version = version })


class ErrorFile extends SaveFile:
	var error: Error


	func _init() -> void:
		version = -1


	func checksum() -> PackedByteArray:
		return []


	func migrate(_storage: SaveFile) -> ErrorFile:
		return self


	func downgrade() -> ErrorFile:
		return self


func _ready() -> void:
	checksums = bytes_to_var(FileAccess.get_file_as_bytes(hash_path))

	for path in DirAccess.get_files_at(files_path):
		var file: SaveFile = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE_DEEP)
		saves[file.id] = file

	for key in saves:
		var file := saves[key]
		file.saved.connect(func(): push_file(file))


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_GO_BACK_REQUEST:
			FileAccess.open(hash_path, FileAccess.WRITE).store_buffer(var_to_bytes(checksums))
		NOTIFICATION_WM_CLOSE_REQUEST:
			FileAccess.open(hash_path, FileAccess.WRITE).store_buffer(var_to_bytes(checksums))


func validate_file(id: String) -> Error:
	if checksums[id] == null:
		return ERR_FILE_CANT_OPEN

	var file := saves[id]

	if file == null:
		return ERR_FILE_NOT_FOUND

	if file.checksum() != checksums[file.id]:
		return ERR_FILE_CORRUPT

	if file.version < 0:
		return ERR_FILE_CORRUPT

	return OK


## Retrieve a save file.
##
## No checks are done to see if it's a valid save file. It will be returned
## regardless if the file had been tampered, corrupted, or not at all.
func get_file(id: String) -> SaveFile:
	return saves[id]


## Retrieve a save file.
##
## The save file will be validated to check if the checksum is valid, if the
## save file exists, or if it has been deemed untampered.
func query_file(id: String) -> SaveFile:
	var result := validate_file(id)

	if result != OK:
		var error := ErrorFile.new()
		error.error = result
		return error

	return get_file(id)


func push_file(file: SaveFile):
	checksums[file.id] = file.checksum()
	saves[file.id] = file
