extends CanvasLayer

@onready var label = $RollLabel
@onready var attack_button = $AttackButton 

func _ready():
	label.hide()
	attack_button.hide()
	attack_button.pressed.connect(_on_attack_pressed)

func start_dice_roll():
	label.show()
	for i in range(15):
		label.text = "ROLLING: " + str(randi_range(1, 20))
		label.modulate = Color(randf(), randf(), randf()) 
		await get_tree().create_timer(0.05).timeout
	
	label.modulate = Color.WHITE

func show_final_result(p_roll: int, e_roll: int, winner_text: String):
	label.text = "Player: %d\nEnemy: %d\n\n%s" % [p_roll, e_roll, winner_text]

func show_action_buttons():
	attack_button.disabled = false
	attack_button.show()

func _on_attack_pressed():
	attack_button.disabled = true
	attack_button.hide()
	CombatManager.player_attack()
