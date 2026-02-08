extends Node

var player_node: CharacterBody3D
var enemy_node: CharacterBody3D
var is_in_combat: bool = false

func start_combat(player, enemy):
	if is_in_combat: return # Prevent double-starting
	
	is_in_combat = true
	player_node = player
	enemy_node = enemy
	
	# 1. Stop the player from moving
	player_node.set_physics_process(false)
	
	# 2. (Optional) Make them face each other
   # player_node.look_at(enemy_node.global_position)
	
	# 3. Trigger your Combat UI (we can set this up next)
	print("UI: Choose your attack!")
