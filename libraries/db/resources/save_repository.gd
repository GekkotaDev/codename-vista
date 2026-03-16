class_name SaveRepository
extends Resource

@export var checksums: Dictionary[String, PackedByteArray]
@export var saves: Dictionary[String, SaveFile]


class ErrorFile extends SaveFile:
	var error: Error


	func _init() -> void:
		version = -1


	func checksum() -> PackedByteArray:
		return []


	func migrate(_storage: SaveFile) -> Error:
		return ERR_UNCONFIGURED


	func downgrade() -> SaveFile:
		return self


func validate_file(id: String) -> Error:
	if checksums[id] == null:
		return ERR_FILE_CANT_OPEN

	var file := saves[id]

	if file == null:
		return ERR_FILE_NOT_FOUND

	if file.checksum() != checksums[file.id]:
		return ERR_FILE_CORRUPT

	return OK


func get_file(id: String) -> SaveFile:
	return saves[id]


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
