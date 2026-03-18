extends PersistedV0

@export var team: String
@export var coordinates: SaveSchemaV0.Units.Components.Coordinates

@export_group("Stats")
@export var health: SaveSchemaV0.Units.Components.Health
@export var attack: SaveSchemaV0.Units.Components.Attack
@export var speed: SaveSchemaV0.Units.Components.Speed
@export var defense: SaveSchemaV0.Units.Components.Defense
