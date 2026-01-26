##
class_name PersistedCollection
extends Resource

var _resources: Dictionary[String, PersistedResource]

##
var query: QueryBuilder:
	get:
		return QueryBuilder.new(_resources)


##
func drop_by_id(id: String) -> PersistedCollection:
	_resources.erase(id)
	return self


##
func override(resource: PersistedResource) -> PersistedCollection:
	_resources[resource.id] = resource
	return self


##
func push(resource: PersistedResource) -> PersistedCollection:
	if _resources.has(resource.id):
		override(resource)
	return self


##
class QueryBuilder:
	var _resources: Dictionary[String, PersistedResource]


	func _init(resources: Dictionary[String, PersistedResource]) -> void:
		_resources = resources.duplicate_deep()


	##
	func scoped(callback: Callable) -> QueryBuilder:
		callback.call(self)
		return self


	##
	func retrieve(id: String) -> PersistedResource:
		return _resources.get(id)


	##
	func filter(callback: Callable) -> QueryBuilder:
		var clone = _resources.duplicate_deep()

		for key in _resources:
			if callback.call(key, clone[key]) == false:
				_resources.erase(key)

		return self


	##
	func map(callback: Callable) -> QueryBuilder:
		var clone = _resources.duplicate_deep()

		for key in _resources:
			_resources[key] = callback.call(key, clone[key])

		return self


	##
	func reduce(
			callback: Callable,
	) -> PersistedResource:
		var values = _resources.values()
		var result = values.pop_back()

		for value in values:
			result = callback.call(result, values)

		return result
