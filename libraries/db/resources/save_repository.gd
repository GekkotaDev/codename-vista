class_name SaveRepository
extends Resource

@export var saves: Dictionary[String, SaveFile]


func query_file(id: String):
	return saves[id]


func push_file(file: SaveFile):
	saves[file.id] = file
