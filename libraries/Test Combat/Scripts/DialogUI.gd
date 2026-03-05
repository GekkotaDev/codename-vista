extends CanvasLayer

# --- Node References ---
@onready var npc_name_label = $NPCDialogBox/NameLabel
@onready var npc_text_label = $NPCDialogBox/NPCText
@onready var options_container = $PlayerDialogBox/OptionsVBox
@onready var option_button_prefab = preload("res://libraries/Test Combat/Ui/Scenes/DialogOptionBtn.tscn")

# --- Logic Variables ---
var current_data: HomelessDialogData
var step: int = 0
var is_waiting_for_input: bool = false
var frame_guard: bool = false

# --- Sequence Variables ---
var npc_reply_sequence: Array[String] = []
var npc_sequence_index: int = 0

func _ready():
	hide()
	layer = 10 

func setup_dialog(data: HomelessDialogData, n_name: String):
	if data == null:
		return
		
	# Set the Name Label
	if npc_name_label:
		npc_name_label.text = n_name # uses NPC's entity name
	
	current_data = data
	step = 0
	is_waiting_for_input = true
	frame_guard = true 
	
	if options_container:
		for child in options_container.get_children():
			child.queue_free()
	
	if current_data.initiation_dialogs.size() > 0:
		npc_text_label.text = current_data.initiation_dialogs.pick_random()
	else:
		npc_text_label.text = "..."
	
	show()
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

	if step == 0:
		npc_text_label.text = current_data.follow_up_initial
		step = 1
		
	elif step == 1:
		is_waiting_for_input = false 
		display_options(current_data.player_options)
		step = 2
		
	elif step == 3:
		npc_sequence_index += 1
		if npc_sequence_index < npc_reply_sequence.size():
			npc_text_label.text = npc_reply_sequence[npc_sequence_index]
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
	npc_reply_sequence = option_obj.npc_reply
	npc_sequence_index = 0
	
	if npc_reply_sequence.size() > 0:
		npc_text_label.text = npc_reply_sequence[0]
	
	for child in options_container.get_children():
		child.queue_free()
		
	is_waiting_for_input = true
	step = 3

func close_dialog():
	hide()
	is_waiting_for_input = false
	step = 0
	npc_sequence_index = 0
	npc_reply_sequence = []
	current_data = null
	get_tree().paused = false
