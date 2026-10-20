extends TextureProgressBar

@export var max_health: int = 100
var current_health: int = max_health
var tween: Tween = null

func _ready():
	max_value = max_health
	value = current_health
	print("Progress bar ready. Current health:", current_health)

	#simulate_damage()

#func simulate_damage():
	#for i in range(5):
		#await get_tree().create_timer(1.0).timeout
		#apply_damage(15)

#func apply_damage(amount: int):
	#var old_health = current_health
	#current_health = clamp(current_health - amount, 0, max_health)

	# If a tween exists, stop it safely
	if tween and tween.is_valid():
		tween.kill()

	# Create a new tween
	tween = create_tween()
	tween.tween_property(self, "value", current_health, 0.5)

	#print("Damage applied:", amount, " | Health:", current_health)
