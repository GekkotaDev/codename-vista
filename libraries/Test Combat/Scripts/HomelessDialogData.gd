extends Resource
class_name HomelessDialogData

@export_group("Initiation")
@export var initiation_dialogs: Array[String] = ["Hmmm....", "I'm hungry", "What?"]
@export var follow_up_initial: String = "Can you give me money?"

@export_group("Player Options")

# Using the custom DialogOption resource instead of Dictionaries/Arrays
@export var player_options: Array[DialogOption]
