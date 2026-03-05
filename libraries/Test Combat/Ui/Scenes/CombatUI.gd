extends CanvasLayer

# in the = $, use the name of the button on your CombatUI scene
@onready var label = $RollLabel
@onready var attack_button = $AttackButton 
@onready var poison_button = $PoisonButton 

func _ready():
	# Hide at the start
	label.hide()
	attack_button.hide()
	poison_button.hide() 
	
	attack_button.pressed.connect(_on_attack_pressed)
	# Connect Poison Button
	poison_button.pressed.connect(_on_poison_pressed)

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
	# --- NEW: Show Poison Button ---
	poison_button.disabled = false
	poison_button.show()

func _on_attack_pressed():

	_hide_buttons()
	CombatManager.player_basic_attack()

# Poison Button Pressed Logic
func _on_poison_pressed():
	_hide_buttons()
	CombatManager.player_poison_attack()

# function to hide buttons
func _hide_buttons():
	attack_button.disabled = true
	attack_button.hide()
	poison_button.disabled = true
	poison_button.hide()
