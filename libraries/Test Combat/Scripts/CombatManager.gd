extends Node

# Preload the scene so it's ready to go
var ui_scene = preload("res://libraries/Test Combat/Ui/Scenes/CombatUI.tscn")
var current_ui = null

var player_node: CharacterBody3D
var enemy_node: CharacterBody3D
var is_in_combat: bool = false

func start_combat(player, enemy):
	if is_in_combat: return
	is_in_combat = true
	
	player_node = player
	enemy_node = enemy

	# 1. Wait for player to land if they were jumping
	if not player_node.is_on_floor():
		print("Waiting for player to land...")
		while not player_node.is_on_floor():
			await get_tree().physics_frame
	
	# 2. Freeze the player and make them face the enemy
	player_node.velocity = Vector3.ZERO
	player_node.set_physics_process(false)
	player_node.look_at(enemy_node.global_position, Vector3.UP)
	
	# 3. Create and show the UI
	current_ui = ui_scene.instantiate()
	get_tree().root.add_child(current_ui)
	
	# 4. Start the dice animation (Defined in your CombatUI.gd)
	await current_ui.start_dice_roll()
	
	# 5. Determine Initiative
	await run_initiative_logic()

func run_initiative_logic():
	var p_roll = randi_range(1, 20)
	var e_roll = randi_range(1, 20)
	
	# Prevent ties
	while p_roll == e_roll: 
		e_roll = randi_range(1, 20)
	
	var winner_text = ""
	if p_roll > e_roll:
		winner_text = "PLAYER GOES FIRST!"
	else:
		winner_text = "ENEMY STRIKES FIRST!"
	
	# Update the UI with the final result
	current_ui.show_final_result(p_roll, e_roll, winner_text)
	
	# Wait for player to read it
	await get_tree().create_timer(2.0).timeout
	
	# 6. Direct to the correct turn
	if p_roll > e_roll:
		start_player_turn()
	else:
		start_enemy_turn()

func start_player_turn():
	print("It is the Player's turn!")
	if current_ui:
		current_ui.label.text = "YOUR TURN\nChoose an Action"
	# This is where you will eventually enable your Attack/Run buttons

func start_enemy_turn():
	print("Enemy AI is thinking...")
	if current_ui:
		current_ui.label.text = "ENEMY TURN\nPreparing to strike..."
	
	# Simple delay to simulate "thinking"
	await get_tree().create_timer(1.5).timeout
	
	# For now, we'll just hand it back to the player so the game doesn't loop forever
	start_player_turn()

func end_combat():
	# Clean up UI and unfreeze player
	if current_ui:
		current_ui.queue_free()
		current_ui = null
	
	is_in_combat = false
	if player_node:
		player_node.set_physics_process(true)
	print("Combat Ended")
