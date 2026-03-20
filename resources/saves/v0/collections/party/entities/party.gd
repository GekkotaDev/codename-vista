extends PersistedV0

const Class := preload("./party.gd")

@export var members: Array[SaveSchemaV0.UseUnits.Entities.Unit] = []
@export var escorts: Array[SaveSchemaV0.UseUnits.Entities.Unit] = []
@export var allies: Array[Class] = []
