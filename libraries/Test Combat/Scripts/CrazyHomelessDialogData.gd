extends Resource

class_name CrazyHomelessDialogData

@export_group("Initiation")
@export var initiation_dialogs: Array[String] = ["Hey give me your money !", "I'm gonna get ya !", "You're not gonna take me alive !"]

@export_group("Player Options")

# Using the custom DialogOption resource instead of Dictionaries/Arrays
@export var player_options: Array[DialogOption]
