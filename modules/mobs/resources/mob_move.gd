@abstract
class_name MobMove
extends Resource

static var name: StringName

@export var lifespan: int = 1


@abstract
func inflict_effect(stats: MobStats)
