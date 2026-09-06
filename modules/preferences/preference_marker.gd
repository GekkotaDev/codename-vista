## Mark a parent node as storing user preferences.
@tool
class_name PreferenceMarker extends Node

## Hydration key.
## [br]
## A [b]unique[/b] identifier used during hydrating the value from disk and when
## persisting data to disk.
@export var key: StringName

## Observed node property.
@export var property: String


## Node that represents the user preference.
var node: Node


func _ready() -> void:
	node = get_parent()
