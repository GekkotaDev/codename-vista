class_name BattleParticipant3D
extends Node3D

@export var id: StringName
@export var stats: MobStats
@export var moves: Array[MobMove]
@export var tree: BeehaveTree
@export var target: BattleParticipant3D

var active: bool


func tick(tree: BeehaveTree):
	tree.enable()
