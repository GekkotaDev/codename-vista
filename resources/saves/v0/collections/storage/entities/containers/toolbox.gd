extends SaveSchemaV0.UseStorage.Entities.Containers.Containers

@export var items: Array[SaveSchemaV0.UseStorage.Entities.Items.Item] = []


func push(item: Resource) -> Error:
	items.push_back(item)
	return OK


func pop(item_id: String) -> Error:
	if items.size() <= 0:
		return ERR_OUT_OF_MEMORY

	var item_index := items.find_custom(
		func(item: SaveSchemaV0.UseStorage.Entities.Items.Item):
			return item.item_id == item_id
	)

	if item_index < 0:
		return ERR_DOES_NOT_EXIST

	items.pop_at(item_index)
	return OK
