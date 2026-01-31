extends ControlFocusSelector

# I could make this an @export_multiline but it risks becoming lost when refactoring
# (e.g: refactoring this node itself, the scene tree it is used in, etc.)

@export var description: SettingDescription
@export var label: RichTextLabel


func on_focus(node: Control):
	node.focus_entered.connect(
		func():
			label.text = description.description
	)
