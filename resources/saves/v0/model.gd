class_name SaveFileV0Model
extends Resource

@export var party: SaveSchemaV0.Party.Entities.Party = (
	SaveSchemaV0.Party.Entities.Party.new()
)

@export var story: SaveSchemaV0.Story.Entities.Story = (
	SaveSchemaV0.Story.Entities.Story.new()
)

@export var rooms: Array[SaveSchemaV0.Room.Entities.Room] = []

@export var room: SaveSchemaV0.Room.Entities.Room = (
	SaveSchemaV0.Room.Entities.Room.NullRoom.new()
)
