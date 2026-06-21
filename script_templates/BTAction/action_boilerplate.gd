## 
extends BTAction

#? Parameters
# @export var bb_x: BBNode

#? State

#? Lifecycle hooks
func _setup() -> void:
	pass

# func _enter() -> void:
# 	pass

# func _exit() -> void:
# 	pass


func _tick(_delta: float) -> Status:
	return BT.Status.FRESH
