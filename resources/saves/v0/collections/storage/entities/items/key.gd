@abstract
extends SaveSchemaV0.UseStorage.Entities.Items.Item

@export var name: String


@abstract func on_acquire() -> void


@abstract func reset() -> void
