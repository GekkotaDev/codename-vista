@abstract
class_name MobMove
extends Resource

static var name: StringName

@export var lifespan: int = 1

@export_group("Turns")
@export var maximum_turns: int = -1
@export var current_turns: int = -1


@abstract
func inflict_effect(stats: MobStats)
