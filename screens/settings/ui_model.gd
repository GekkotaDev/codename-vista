extends ResourceModel

enum SettingsTab {
	AUDIO,
	VIDEO,
	CONTROLS,
	EXTRAS,
}

@export var tab: SettingsTab = SettingsTab.AUDIO:
	set(value):
		tab = change("tab", value)
