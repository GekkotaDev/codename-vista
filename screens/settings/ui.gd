extends SceneView

const Model = preload("./ui_model.gd")


func on_pressed_tab(event_bus: EventBus, node_name: String, tab: Model.SettingsTab):
	var model = resource_model as Model

	event_bus.connect_of(
		node_name,
		&"pressed",
		func():
			set_state(
				func():
					model.tab = tab
			)
	)


func _script(events: EventBus, _model: ResourceModel):
	# model = model as Model

	on_pressed_tab(events, "audio_button", Model.SettingsTab.AUDIO)
	on_pressed_tab(events, "video_button", Model.SettingsTab.VIDEO)
	on_pressed_tab(events, "controls_button", Model.SettingsTab.CONTROLS)
	on_pressed_tab(events, "extras_button", Model.SettingsTab.EXTRAS)


func _view(model: ResourceModel):
	model = model as Model

	effect(
		["tab"],
		func():
			var tabs: MarginContainer = nodes.get("settings_container")
			if tabs == null:
				return

			for child in tabs.get_children():
				if "visible" not in child:
					continue
				child.visible = false

			match model.tab:
				Model.SettingsTab.AUDIO:
					nodes["audio_settings"].visible = false
				Model.SettingsTab.VIDEO:
					nodes["video_settings"].visible = false
				Model.SettingsTab.CONTROLS:
					nodes["controls_settings"].visible = false
				Model.SettingsTab.EXTRAS:
					pass
	)
