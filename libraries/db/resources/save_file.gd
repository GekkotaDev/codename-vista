##
@abstract
class_name SaveFile
extends Resource

##
@export var collections: Dictionary[String, PersistedResource]

##
@export var version: int = 0


##
@abstract func checksum() -> String


##
@abstract func migrate(storage: SaveFile) -> Error


##
@abstract func downgrade() -> SaveFile
