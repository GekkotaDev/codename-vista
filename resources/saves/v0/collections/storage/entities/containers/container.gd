@abstract
extends PersistedV0

@abstract func push(item: Resource) -> Error


@abstract func pop(item_id: String) -> Error
