## 
class_name EventBus
extends Node

@export var nodes: Dictionary[String, Control] = { }


##
func connect_of(
		control_name: String,
		signal_name: StringName,
		callback: Callable,
		flag: int = 0,
):
	if nodes.has(control_name):
		return nodes[control_name].connect(signal_name, callback, flag)
