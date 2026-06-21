class_name SaveFileV0Model
extends Resource

@export var party: SaveSchemaV0.UseParty.Entities.Party = (
	SaveSchemaV0.UseParty.Entities.Party.new()
)

@export var story: SaveSchemaV0.UseStory.Entities.Story = (
	SaveSchemaV0.UseStory.Entities.Story.new()
)

@export var rooms: Array[SaveSchemaV0.UseRoom.Entities.Room] = []

@export var room: SaveSchemaV0.UseRoom.Entities.Room = (
	SaveSchemaV0.UseRoom.Entities.Room.NullRoom.new()
)
