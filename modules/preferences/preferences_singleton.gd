@abstract
@icon("res://addons/player_preferences/icons/cog.svg")
class_name PreferencesSingleton extends Node

## Preferences data.
@export var data: PreferencesData


## Hydration hook applied to each [PreferenceMarker]
## [br]
## Custom behavior for restoring settings data may be defined here otherwise
## a convenience function is provided that implements the default behavior.
@abstract func _hydrate(marker: PreferenceMarker)


## Persistence hook applied to each [PreferenceMarker]
## [br]
## Custom save behavior is defined here, otherwise, a convenience function is
## provided implementing default persistence behavior.
@abstract func _persist(marker: PreferenceMarker)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		data.persist_preferences()


## Utility function to hydrate the node from disk.
func hydrate(marker: PreferenceMarker):
	data.hydrate_value(marker)


## Utility function to persist the node data to disk.
func persist(marker: PreferenceMarker):
	data.store_value(marker)


## Load preferences from disk, restoring the values of the nodes.
## [br]
## This is typically used whenever the user accesses the settings menu. This
## method assumes the existence of [PreferenceMarker]s within the scene.
func load_preferences():
	data.hydrate_preferences()
	var markers := find_children("*", &"PreferenceMarker") as Array[PreferenceMarker]
	for marker in markers:
		_hydrate(marker)


## Apply changes to the current preferences.
func save_preferences():
	var markers := find_children("*", &"PreferenceMarker") as Array[PreferenceMarker]
	for marker in markers:
		_persist(marker)
	data.persist_preferences()
