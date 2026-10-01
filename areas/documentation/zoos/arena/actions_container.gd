extends MarginContainer

@export var visitor: BattleVisitor3D
@export var action: PackedScene

var participant: BattleParticipant3D:
	get:
		return visitor.participant

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_next():
	participant.moves[0]
