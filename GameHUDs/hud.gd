extends Control

func _ready():
	call_deferred("_connect_player")

func _connect_player():
	var player = get_node_or_null("res://Characters/ViolaCharacter.tscn")
	if player:
		player.connect("health_changed", Callable(self, "_on_health_changed"))

func _on_health_changed(current_hp):
	$TextureProgressBar.value = current_hp
