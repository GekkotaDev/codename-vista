@abstract
class_name MobMove
extends Resource

static var name: StringName

@export var lifespan: int = 1


@abstract
func inflict_effect(participant: BattleParticipant3D)


func tick(participant: BattleParticipant3D):
	if lifespan > 0:
		lifespan = lifespan - 1
	inflict_effect(participant)
