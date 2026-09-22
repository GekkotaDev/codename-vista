class_name BattleParticipant3D
extends Node3D

@export var id: StringName

@export_group("Data")
@export var stats: MobStats
@export var moves: Array[MobMove]
@export var modifiers: Array[MobModifier]

@export_group("Brain")
@export var tree: BeehaveTree
@export var target: BattleParticipant3D


func _ready() -> void:
	for modifier in modifiers:
		modifier.on_spawn(self)
	start()


func start():
	for modifier in modifiers:
		modifier.on_trigger(self)


func tick() -> bool:
	for modifier in modifiers:
		modifier.on_tick(self)
	return tree.enabled


func terminate():
	for modifier in modifiers:
		modifier.on_terminate(self)
