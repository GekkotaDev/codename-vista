@abstract
extends SaveSchemaV0.UseStorage.Entities.Items.Item

@export var users: Array[SaveSchemaV0.UseUnits.Entities.Unit]
@export var targets: SaveSchemaV0.UseStorage.Components.Target


@abstract func on_equip() -> void


@abstract func on_remove() -> void


@abstract func on_deploy() -> void
