@abstract
class_name MobModifier extends Resource

enum Lifecycle {
	SPAWN,
	TRIGGER,
	TICK,
	TERMINATE,
}

# @abstract
signal lifecycle(lifecycle: Lifecycle)


@abstract
func on_spawn(mob: BattleParticipant3D) -> void


@abstract
func on_trigger(mob: BattleParticipant3D) -> void


@abstract
func on_tick(mob: BattleParticipant3D) -> void


@abstract
func on_terminate(mob: BattleParticipant3D) -> void
