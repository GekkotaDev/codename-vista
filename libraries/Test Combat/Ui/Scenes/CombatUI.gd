# CombatUI.gd
extends CanvasLayer

@onready var label = $RollLabel

func _ready():
	# Hide label initially
	label.hide()

func start_dice_roll():
	label.show()
	
	# The "Flicker" effect
	for i in range(15):
		label.text = "ROLLING: " + str(randi_range(1, 20))
		# Change color randomly for visual flair
		label.modulate = Color(randf(), randf(), randf()) 
		await get_tree().create_timer(0.05).timeout
	
	label.modulate = Color.WHITE # Reset color to white

func show_final_result(p_roll: int, e_roll: int, winner_text: String):
	label.text = "Player: %d\nEnemy: %d\n\n%s" % [p_roll, e_roll, winner_text]
