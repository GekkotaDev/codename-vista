extends Node

var ui_scene = preload("res://libraries/Test Combat/Ui/Scenes/CombatUI.tscn")
var current_ui = null

var player_node: CharacterBody3D
var enemy_node: CharacterBody3D
var is_in_combat: bool = false

# Flag to track whose turn it is
var can_player_act: bool = false
var can_enemy_act: bool = false

func start_combat(player, enemy):
	if is_in_combat: return
	is_in_combat = true
	
	player_node = player
	enemy_node = enemy

	if not player_node.is_on_floor():
		while not player_node.is_on_floor():
			await get_tree().physics_frame
	
	player_node.set_physics_process(false)
	
	current_ui = ui_scene.instantiate()
	get_tree().root.add_child(current_ui)
	
	await current_ui.start_dice_roll()
	
	var p_roll = randi_range(1, 20)
	var e_roll = randi_range(1, 20)
	while p_roll == e_roll: e_roll = randi_range(1, 20) # No ties
	
	var winner = "PLAYER GOES FIRST" if p_roll > e_roll else "ENEMY GOES FIRST"
	current_ui.show_final_result(p_roll, e_roll, winner)
	
	await get_tree().create_timer(2.0).timeout
	
	if p_roll > e_roll:
		start_player_turn()
	else:
		start_enemy_turn()

func end_combat():
	if current_ui:
		current_ui.queue_free()
		current_ui = null
	
	is_in_combat = false
	can_player_act = false
	can_enemy_act = false
	player_node.set_physics_process(true)
	print("Combat Ended")

func start_player_turn():
	print("--- Player's Turn ---")
	can_player_act = true
	can_enemy_act = false
	if current_ui:
		current_ui.label.text = "YOUR TURN\nChoose an Action"
		current_ui.show_action_buttons()

func start_enemy_turn():
	print("--- Enemy's Turn ---")
	can_player_act = false
	can_enemy_act = true
	if current_ui:
		current_ui.label.text = "ENEMY TURN\nPreparing to strike..."
	
	await get_tree().create_timer(1.5).timeout
	enemy_attack()

# DAMAGE FUNCTIONS
func player_attack():
	if not can_player_act: return
	
	print(">>> Player Action Started (Instant)")
	
	
	var p_data = HealthManager.get_entity_data("Player")
	var e_name = enemy_node.data.name
	
	# 1. INSTANT DAMAGE (Triggers signal automatically)
	HealthManager.update_hp(e_name, -p_data.attack_damage)
	
	# 2. LOCK TURN
	can_player_act = false
	
	# 3. Check for death
	if HealthManager.get_hp(e_name) <= 0:
		if enemy_node.has_method("die"):
			enemy_node.die()
		end_combat()
	else:
		start_enemy_turn()

func enemy_attack():
	if not can_enemy_act: return
	
	print(">>> Enemy Action Started (Instant)")
	

	var e_data = HealthManager.get_entity_data(enemy_node.data.name)
	
	# 1. INSTANT DAMAGE
	HealthManager.update_hp("Player", -e_data.attack_damage)
	
	# 2. LOCK TURN
	can_enemy_act = false
	
	# 3. Check for death
	if HealthManager.get_hp("Player") <= 0:
		print("GAME OVER")
		# Add game over logic here
	else:
		start_player_turn()
