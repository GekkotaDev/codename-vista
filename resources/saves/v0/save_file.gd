class_name SaveFileV0
extends SaveFile

@export var query: SaveFileV0Model


func checksum() -> PackedByteArray:
	return generate_checksum(query)


func migrate(_storage: SaveFile) -> SaveFile:
	# Latest version still V0
	return self


func downgrade() -> SaveFile:
	return self
