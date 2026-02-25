extends ProgressBar

@export var entity_name: String = "Player" # Set this to "Enemy" in the inspector for enemies

func _ready():
	# Initial set
	max_value = HealthManager.max_health_data.get(entity_name, 100)
	value = HealthManager.get_hp(entity_name)
	
	# Listen for any health changes globally
	HealthManager.hp_changed.connect(_on_hp_changed)

func _on_hp_changed(target_name, new_hp):
	if target_name == entity_name:
		
		# Animate the bar shrinking
		var tween = create_tween()
		tween.tween_property(self, "value", new_hp, 0.3).set_trans(Tween.TRANS_SINE)
