extends PersistedV0

@export var name: String = ""
@export var coordinates: SaveSchemaV0.UseUnits.Components.Coordinates = (
	SaveSchemaV0.UseUnits.Components.Coordinates.new()
)

@export_group("Identifiers")
@export var team_id: String = ""
@export var unit_id: String = ""

@export_group("Stats")
@export var health: SaveSchemaV0.UseUnits.Components.Health = (
	SaveSchemaV0.UseUnits.Components.Health.new()
)
@export var attack: SaveSchemaV0.UseUnits.Components.Attack = (
	SaveSchemaV0.UseUnits.Components.Attack.new()
)
@export var speed: SaveSchemaV0.UseUnits.Components.Speed = (
	SaveSchemaV0.UseUnits.Components.Speed.new()
)
@export var defense: SaveSchemaV0.UseUnits.Components.Defense = (
	SaveSchemaV0.UseUnits.Components.Defense.new()
)
