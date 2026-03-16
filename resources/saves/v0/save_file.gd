class_name SaveFileV0
extends SaveFile

@export var model: Model


class Model extends Resource:
	@export var player: PersistedV0Player


func checksum() -> PackedByteArray:
	return serialize_checksum(model)


func migrate(_storage: SaveFile) -> SaveFile:
	# Latest version still V0
	return self


func downgrade() -> SaveFile:
	return self
