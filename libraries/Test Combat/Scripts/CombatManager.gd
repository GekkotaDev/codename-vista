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

# --- NEW UPDATED LOGIC (Signal for NPCs) ---
# This signal will help NPCs know combat is officially over
signal combat_finished

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
	# --- NEW UPDATED LOGIC (Signal Emission) ---
	# We emit this before cleaning up so nodes can react
	combat_finished.emit()
	
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
	# --- NEW UPDATED LOGIC (Safety Check) ---
	# If the enemy died during the turn transition (like from poison), stop here.
	if not is_instance_valid(enemy_node) or HealthManager.get_hp(enemy_node.entity_name) <= 0:
		# --- NEW AGGRESSIVE CHECK ---
		if is_instance_valid(enemy_node) and HealthManager.get_hp(enemy_node.entity_name) <= 0:
			_force_enemy_death()
		return

	print("--- Player's Turn ---")
	can_player_act = true
	can_enemy_act = false
	if current_ui:
		current_ui.label.text = "YOUR TURN\nChoose an Action"
		current_ui.show_action_buttons()

func start_enemy_turn():
	# --- NEW UPDATED LOGIC (Safety Check) ---
	if not is_instance_valid(enemy_node) or HealthManager.get_hp(enemy_node.entity_name) <= 0:
		# --- NEW AGGRESSIVE CHECK ---
		if is_instance_valid(enemy_node):
			_force_enemy_death()
		return

	print("--- Enemy's Turn ---")
	can_player_act = false
	can_enemy_act = true
	if current_ui:
		current_ui.label.text = "ENEMY TURN\nPreparing to strike..."
	
	await get_tree().create_timer(1.5).timeout
	
	# Final check before enemy attacks
	if is_in_combat:
		enemy_attack()

# DAMAGE FUNCTIONS
func player_basic_attack():
	if not can_player_act: return
	
	print(">>> Player Action Started (Instant)")
	
	# Get damage from Resource
	var p_data = HealthManager.get_entity_data("Player")
	
	# We use the unique entity_name property from the node to find the specific resource
	var e_name = "Unknown"
	if "entity_name" in enemy_node:
		e_name = enemy_node.entity_name

	# --- NEW UPDATED LOGIC (Safe Get) ---
	var damage = 0
	if p_data and p_data.has_method("get"):
		var val = p_data.get("basic_attack_damage")
		if val != null:
			damage = val

	# 1. INSTANT DAMAGE (Triggers signal automatically)
	HealthManager.update_hp(e_name, -damage)
	
	# LOCK TURN
	can_player_act = false
	
	# Check for death
	if HealthManager.get_hp(e_name) <= 0:
		# --- NEW UPDATED LOGIC (Force Cleanup) ---
		# --- ORIGINAL CODE (Turned into comments) ---
		# if is_instance_valid(enemy_node) and enemy_node.has_method("die"):
		# 	enemy_node.die()
		
		_force_enemy_death()
		end_combat()
	else:
		start_enemy_turn()

# Poison Attack Logic
func player_poison_attack():
	if not can_player_act: return
	
	var p_data = HealthManager.get_entity_data("Player") 
	var e_data = enemy_node.data
	
	var e_name = "Unknown"
	if "entity_name" in enemy_node:
		e_name = enemy_node.entity_name
	
	print(">>> Player used Poison Attack!")
	
	# --- NEW UPDATED LOGIC (Safe Get for Poison) ---
	var init_dmg = p_data.get("poison_attack_initial_damage") if p_data.get("poison_attack_initial_damage") != null else 0
	var tick_dmg = p_data.get("poison_damage_per_tick") if p_data.get("poison_damage_per_tick") != null else 0
	var duration = p_data.get("poison_duration") if p_data.get("poison_duration") != null else 1.0
	
	# Initial Instant Damage
	HealthManager.update_hp(e_name, -init_dmg) 
	
	# Handle Poison Stacking and Timer Refresh (Safe Set/Get)
	var is_p = e_data.get("is_poisoned") if e_data.get("is_poisoned") != null else false
	var cur_p_dmg = e_data.get("current_poison_damage") if e_data.get("current_poison_damage") != null else 0

	if is_p:
		print("Poison Stacked! Timer Refreshed.")
		e_data.set("current_poison_damage", cur_p_dmg + tick_dmg)
	else:
		print("Enemy Poisoned!")
		e_data.set("is_poisoned", true)
		e_data.set("current_poison_damage", tick_dmg)
		
	# Refresh/Start the timer
	poison_timer = get_tree().create_timer(duration)
	
	# 3. Apply Damage Over Time
	_apply_poison_ticks(e_data, p_data, e_name) 
	
	can_player_act = false
	
	# Check if initial damage killed them
	if HealthManager.get_hp(e_name) <= 0:
		# --- NEW UPDATED LOGIC (Force Cleanup) ---
		# --- ORIGINAL CODE (Turned into comments) ---
		# if is_instance_valid(enemy_node) and enemy_node.has_method("die"):
		# 	enemy_node.die()

		_force_enemy_death()
		end_combat()
	else:
		start_enemy_turn()

# function to handle DOT ticks
func _apply_poison_ticks(e_data: Resource, p_data: PlayerData, e_name: String):
	# Keep track of the current timer instance to prevent overlap issues
	var current_timer = poison_timer
	
	while current_timer and current_timer.time_left > 0:
		var tick_rate = p_data.get("poison_tick_rate") if p_data.get("poison_tick_rate") != null else 1.0
		await get_tree().create_timer(tick_rate).timeout
		
		# If combat ended or timer was replaced, stop this loop
		if not is_in_combat or current_timer != poison_timer:
			return
			
		var cur_tick_dmg = e_data.get("current_poison_damage") if e_data.get("current_poison_damage") != null else 0
		print("Poison Tick: ", cur_tick_dmg, " damage on ", e_name)
		HealthManager.update_hp(e_name, -cur_tick_dmg)
		
		# Check for death after tick
		if HealthManager.get_hp(e_name) <= 0:
			# --- NEW UPDATED LOGIC (Immediate Resolution) ---
			# --- ORIGINAL CODE (Turned into comments) ---
			# if is_instance_valid(enemy_node) and enemy_node.has_method("die"):
			# 	enemy_node.die()
			
			_force_enemy_death()
			end_combat()
			return

	# Poison wore off
	if e_data.get("is_poisoned"):
		print("Poison wore off.")
		e_data.set("is_poisoned", false)
		e_data.set("current_poison_damage", 0)

func enemy_attack():
	# --- NEW UPDATED LOGIC (Death Check before Attack) ---
	if not is_in_combat or not is_instance_valid(enemy_node):
		return

	if not can_enemy_act: return
	
	print(">>> Enemy Action Started (Instant)")
	
	# Get damage from Enemy Resource
	var e_data = enemy_node.data
	
	# --- NEW UPDATED LOGIC (Safe Get with Null-Check) ---
	var dmg = 0
	if e_data != null and e_data.has_method("get"):
		var raw_val = e_data.get("attack_damage")
		if raw_val != null:
			dmg = raw_val
		else:
			print("CombatManager Error: 'attack_damage' not found on ", enemy_node.name)
	
	# INSTANT DAMAGE
	HealthManager.update_hp("Player", -dmg)
	
	# LOCK TURN
	can_enemy_act = false
	
	# Check for death
	if HealthManager.get_hp("Player") <= 0:
		print("GAME OVER")
	else:
		start_player_turn()

# --- NEW NUCLEAR CLEANUP FUNCTION ---
func _force_enemy_death():
	if is_instance_valid(enemy_node):
		print("DEBUG: CombatManager forcing death call on ", enemy_node.name)
		if enemy_node.has_method("die"):
			enemy_node.die()
		else:
			# If the script swap somehow broke the die() method, we kill it manually
			print("DEBUG WARNING: NPC missing die() method. Forcing queue_free.")
			enemy_node.queue_free()
	else:
		print("DEBUG ERROR: enemy_node was already invalid, but still exists in scene?")   
