@abstract
@tool
class_name RouterNode
extends Node

@export var edges: Dictionary[String, RouterNode] = { }

@export_group("Transitions")
@export var in_transition: AnimationController
@export var out_transition: AnimationController

var root = true


##
@abstract func reveal() -> void


##
@abstract func goto(destination: String) -> RouterNode


##
func on_reveal():
	pass


##
func on_postreveal():
	pass


##
func on_leave():
	pass


##
func on_postleave():
	pass
