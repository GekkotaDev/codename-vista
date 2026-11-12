extends CanvasLayer

func change_scene(target: String) -> void:
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	Hud.visible = target != "res://scenes/main_menu.tscn"
	$AnimationPlayer.play_backwards("dissolve")
