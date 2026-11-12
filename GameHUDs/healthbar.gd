extends TextureProgressBar

@export var max_health: int = 100
var current_health: int = max_health
var tween: Tween = null

func _ready() -> void:
	max_value = max_health
	value = current_health
	print("Progress bar ready. Current health:", current_health)
	
	# Connect to scene changes and check immediately
	get_tree().tree_changed.connect(_on_tree_changed)
	call_deferred("_check_scene")

func _on_tree_changed() -> void:
	if is_inside_tree():
		call_deferred("_check_scene")

func _check_scene() -> void:
	var current_scene = get_tree().current_scene
	if current_scene == null:
		return
		
	# Make sure "MainMenu" matches the exact name of your menu's root node
	if current_scene.name == "MainMenu":
		hide()
	else:
		show()

# Call this function from your player or enemy scripts when taking damage
func update_health(new_health: int) -> void:
	current_health = clamp(new_health, 0, max_health)
	
	if tween and tween.is_valid():
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "value", current_health, 0.5)
