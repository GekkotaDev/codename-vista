class_name DictionaryTools

var dictionary: Dictionary[Variant, Variant]:
	get():
		return dictionary.duplicate_deep()


func _init(value: Dictionary[Variant, Variant] = { }) -> void:
	dictionary = value.duplicate_deep()


func filter(callback: Callable) -> DictionaryTools:
	var clone := dictionary.duplicate_deep()

	for key in dictionary:
		if callback.call(key, clone[key]) == false:
			dictionary.erase(key)

	return self


##
func map(callback: Callable) -> DictionaryTools:
	var clone := dictionary.duplicate_deep()

	for key in dictionary:
		dictionary[key] = callback.call(key, clone[key])

	return self
