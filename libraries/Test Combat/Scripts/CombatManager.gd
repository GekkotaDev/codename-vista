extends Node

var ui_scene = preload("res://libraries/Test Combat/Ui/Scenes/CombatUI.tscn")
var current_ui = null

var player_node: CharacterBody3D
var enemy_node: CharacterBody3D
var is_in_combat: bool = false

# track whose turn it is
var can_player_act: bool = false
var can_enemy_act: bool = false

# Timer for Poison
var poison_timer: SceneTreeTimer = null

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
	
	# Clear poison timer if combat ends early
	poison_timer = null 
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
func player_basic_attack():
	if not can_player_act: return
	
	print(">>> Player Action Started (Instant)")
	
	# Get damage from Resource
	var p_data = HealthManager.get_entity_data("Player")
	var e_name = enemy_node.data.name
	
	# 1. INSTANT DAMAGE (Triggers signal automatically)
	HealthManager.update_hp(e_name, -p_data.basic_attack_damage)
	
	# LOCK TURN
	can_player_act = false
	
	# Check for death
	if HealthManager.get_hp(e_name) <= 0:
		if enemy_node.has_method("die"):
			enemy_node.die()
		end_combat()
	else:
		start_enemy_turn()

# Poison Attack Logic
func player_poison_attack():
	if not can_player_act: return
	
	var p_data = HealthManager.get_entity_data("Player") # Added to get player stats
	var e_data = enemy_node.data
	var e_name = e_data.name
	
	print(">>> Player used Poison Attack!")
	
	# Initial Instant Damage from Player Resource
	HealthManager.update_hp(e_name, -p_data.poison_attack_initial_damage) 
	
	# Handle Poison Stacking and Timer Refresh
	if e_data.is_poisoned:
		print("Poison Stacked! Timer Refreshed.")
		e_data.current_poison_damage += p_data.poison_damage_per_tick 
	else:
		print("Enemy Poisoned!")
		e_data.is_poisoned = true
		e_data.current_poison_damage = p_data.poison_damage_per_tick
		
	# Refresh/Start the timer
	poison_timer = get_tree().create_timer(p_data.poison_duration)
	
	# 3. Apply Damage Over Time
	_apply_poison_ticks(e_data, p_data) # Passed p_data to check duration/tick rate
	
	can_player_act = false
	
	# Check if initial damage killed them
	if HealthManager.get_hp(e_name) <= 0:
		if enemy_node.has_method("die"):
			enemy_node.die()
		end_combat()
	else:
		start_enemy_turn()

# function to handle DOT ticks
func _apply_poison_ticks(e_data: EnemyData, p_data: PlayerData):
	# Keep track of the current timer instance to prevent overlap issues
	var current_timer = poison_timer
	
	while current_timer and current_timer.time_left > 0:
		await get_tree().create_timer(p_data.poison_tick_rate).timeout
		
		# If combat ended or timer was replaced, stop this loop
		if not is_in_combat or current_timer != poison_timer:
			return
			
		print("Poison Tick: ", e_data.current_poison_damage, " damage")
		HealthManager.update_hp(e_data.name, -e_data.current_poison_damage)
		
		# Check for death after tick
		if HealthManager.get_hp(e_data.name) <= 0:
			if enemy_node and enemy_node.has_method("die"):
				enemy_node.die()
			end_combat()
			return

	# Poison wore off
	if e_data.is_poisoned:
		print("Poison wore off.")
		e_data.is_poisoned = false
		e_data.current_poison_damage = 0 

func enemy_attack():
	if not can_enemy_act: return
	
	print(">>> Enemy Action Started (Instant)")
	
	# Get damage from Enemy Resource
	var e_data = enemy_node.data
	
	# INSTANT DAMAGE
	HealthManager.update_hp("Player", -e_data.attack_damage)
	
	# LOCK TURN
	can_enemy_act = false
	
	# Check for death
	if HealthManager.get_hp("Player") <= 0:
		print("GAME OVER")
		# Add game over logic here
	else:
		start_player_turn()
