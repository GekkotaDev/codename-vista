@tool
extends EditorPlugin

func _enable_plugin() -> void:
	var editor := EditorInterface.get_editor_settings()

	editor.set_setting("run/auto_save/save_before_running", true)
	editor.set_setting("run/platforms/linuxbsd/prefer_wayland", true)

	editor.set_setting("gdquest_gdscript_formatter/format_on_save", true)
	editor.set_setting("gdquest_gdscript_formatter/lint_on_save", true)
	editor.set_setting("gdquest_gdscript_formatter/use_spaces", false)
	editor.set_setting("gdquest_gdscript_formatter/indent_size", 4)
