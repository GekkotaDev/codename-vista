@abstract class_name ControlFocusSelector
extends NodeSelector

func run(node):
	if node is Control:
		on_focus(node)
	return Error.ERR_INVALID_PARAMETER


@abstract func on_focus(node: Control)
