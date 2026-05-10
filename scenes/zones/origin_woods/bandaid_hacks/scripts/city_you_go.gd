extends Area3D

@export_group("Scenes")
@export var loading_screen: SceneLoaderTarget
@export var city_scene: SceneLoaderTarget


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Control + Click on [body_entered] to RTFM
	body_entered.connect(
		func(node: Node3D):
			# ! DON'T FORGET TO REMOVE HARD CODED PATHS TO REDUCE MAINTENANCE
			# ! COST, YOU WOULD NOT WANT TO MANUALLY HUNT DOWN WHERE EVERY HARD
			# ! CODED STRING PATH IS FOR A PARTICULAR SCENE.
			#
			# so that's I place them in a custom resource instead of
			# scattered as strings through the codebase, you just
			# need to change it from one file.
			#
			#                          vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
			SceneManager.change_scene("res://libraries/Test Combat/Environment/Scenes/World.tscn")
			
			# anyways thank you for your cooperation :)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
