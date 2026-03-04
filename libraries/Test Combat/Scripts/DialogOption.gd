extends Resource
class_name DialogOption

@export var text: String = ""
@export var npc_reply: Array[String] = []

# This allows for infinite branching dialog
@export var next_options: Array[DialogOption] = []
