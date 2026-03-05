extends CanvasLayer

# --- Node References ---
@onready var npc_name_label = $NPCDialogBox/NameLabel
@onready var npc_text_label = $NPCDialogBox/NPCText
@onready var options_container = $PlayerDialogBox/OptionsVBox
@onready var option_button_prefab = preload("res://libraries/Test Combat/Ui/Scenes/DialogOptionBtn.tscn")

# --- Logic Variables ---
var current_data: Resource # generic Resource to allow different types
var current_npc_node: Node = null 
var current_option_obj: Resource = null # Track the currently active option

# --- PLAYER PERSISTENCE ---
var persistent_player_ref: Node = null 

var step: int = 0
var is_waiting_for_input: bool = false
var frame_guard: bool = false

# --- Sequence Variables ---
var npc_reply_sequence: Array[String] = []
var npc_sequence_index: int = 0

func _ready():
	hide()
	layer = 10 
	pass

# --- UPDATED SETUP_DIALOG ---
# We now accept player_node as an argument to bypass the group lookup failure
func setup_dialog(data: Resource, npc_node: Node, player_node: Node = null):
	if data == null:
		return
		
	if npc_name_label:
		npc_name_label.text = npc_node.entity_name 
	
	current_data = data
	current_npc_node = npc_node
	
	# --- NEW UPDATED LOGIC (Direct Capture with Debug) ---
	if player_node != null:
		persistent_player_ref = player_node
		print("DEBUG: DialogUI persistent_player_ref set to: ", player_node.name)
	else:
		if is_inside_tree():
			persistent_player_ref = get_tree().get_first_node_in_group("Player")
			print("DEBUG: DialogUI searched group and found: ", persistent_player_ref)
		else:
			print("DEBUG WARNING: DialogUI not in tree, cannot search groups.")
	
	step = 0
	is_waiting_for_input = true
	frame_guard = true 
	
	if options_container:
		for child in options_container.get_children():
			child.queue_free()
	
	# --- ROBUST CONDITIONAL LOGIC ---
	var is_aggressive = not ("player_options" in current_data)
	
	if is_aggressive:
		print("DEBUG: Aggressive Dialog Detected (No player_options found)")
		if "initiation_dialogs" in current_data and current_data.initiation_dialogs.size() > 0:
			npc_text_label.text = current_data.initiation_dialogs.pick_random()
		else:
			npc_text_label.text = "!!!"
		step = 100 
	else:
		print("DEBUG: Peaceful Dialog Detected (player_options found)")
		if "initiation_dialogs" in current_data and current_data.initiation_dialogs.size() > 0:
			npc_text_label.text = current_data.initiation_dialogs.pick_random()
		else:
			npc_text_label.text = "..."
		step = 0 
	
	show()
	if is_inside_tree():
		# Ensure mouse is visible and not captured by the player camera
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_viewport().set_input_as_handled()

func _process(_delta):
	if frame_guard:
			frame_guard = false 
			return 
			
	if visible and is_waiting_for_input:
		if Input.is_action_just_pressed("player_interact"):
			advance_dialog()

func advance_dialog():
	if current_data == null: return

	# CRAZY DIALOG ADVANCE (Combat Trigger)
	if step == 100:
		if is_instance_valid(persistent_player_ref) and is_instance_valid(current_npc_node):
			print("DEBUG: Executing CombatManager.start_combat for ", current_npc_node.name)
			
			# --- NEW UPDATED LOGIC (Unpause and Focus Fix) ---
			# We unpause the tree BEFORE starting combat to ensure the CombatUI
			# can process the very first click it receives.
			get_tree().paused = false
			
			if is_inside_tree():
				var focus_owner = get_viewport().gui_get_focus_owner()
				if focus_owner:
					focus_owner.release_focus()
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

			CombatManager.start_combat(persistent_player_ref, current_npc_node)
			
			_force_cleanup_dialog()
			queue_free() 
		else:
			var p_valid = is_instance_valid(persistent_player_ref)
			var n_valid = is_instance_valid(current_npc_node)
			print("DEBUG ERROR: Combat failed. PlayerValid: ", p_valid, " NPCValid: ", n_valid)
			close_dialog()

	# STANDARD DIALOG ADVANCE (Peaceful / Universal)
	elif step == 0:
		if "follow_up_initial" in current_data and current_data.follow_up_initial != "":
			npc_text_label.text = current_data.follow_up_initial
			step = 1
		else:
			step = 1
			advance_dialog()
		
	elif step == 1:
		if "player_options" in current_data:
			is_waiting_for_input = false 
			display_options(current_data.player_options)
			step = 2
		else:
			close_dialog()
		
	elif step == 3:
		npc_sequence_index += 1
		if npc_sequence_index < npc_reply_sequence.size():
			npc_text_label.text = npc_reply_sequence[npc_sequence_index]
		else:
			var has_next = false
			if current_option_obj and "next_options" in current_option_obj:
				if current_option_obj.next_options.size() > 0:
					has_next = true
			
			if has_next:
				is_waiting_for_input = false 
				display_options(current_option_obj.next_options) 
				step = 2 
			else:
				close_dialog()

func display_options(options_list: Array):
	if options_container == null: return
	
	for child in options_container.get_children():
		child.queue_free()
	
	for opt in options_list:
		var btn = option_button_prefab.instantiate()
		
		if btn is Button:
			btn.text = opt.text
		else:
			var lbl = btn.find_child("Label", true, false)
			if lbl: lbl.text = opt.text
		
		btn.mouse_filter = Control.MOUSE_FILTER_STOP
		options_container.add_child(btn)
		
		btn.pressed.connect(_on_option_selected.bind(opt))
	
	options_container.show()

func _on_option_selected(option_obj: DialogOption):
	current_option_obj = option_obj 
	
	npc_reply_sequence = option_obj.npc_reply
	npc_sequence_index = 0
	
	if npc_reply_sequence.size() > 0:
		npc_text_label.text = npc_reply_sequence[0]
	else:
		advance_dialog()
		return
	
	for child in options_container.get_children():
		child.queue_free()
		
	is_waiting_for_input = true 
	step = 3

func _force_cleanup_dialog():
	hide()
	is_waiting_for_input = false
	step = 0
	npc_sequence_index = 0
	npc_reply_sequence = []
	current_data = null
	current_npc_node = null
	current_option_obj = null 
	persistent_player_ref = null

func close_dialog():
	if is_inside_tree():
		var focus_owner = get_viewport().gui_get_focus_owner()
		if focus_owner:
			focus_owner.release_focus()
	
	_force_cleanup_dialog()
	get_tree().paused = false
	queue_free()
