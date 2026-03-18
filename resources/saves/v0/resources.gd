class_name SaveSchemaV0

const _SAVES = "res://resources/saves/v0/collections"


class Party:
	class Entities:
		const Party := preload(
			"res://resources/saves/v0/collections/party/entities/party.gd"
		)


class Room:
	class Components:
		const Event := preload(
			"res://resources/saves/v0/collections/room/components/event.gd"
		)


	class Entities:
		const Room := preload(
			"res://resources/saves/v0/collections/room/entities/room.gd"
		)


class Story:
	class Entities:
		const Chapter := preload(
			"res://resources/saves/v0/collections/story/entities/chapter.gd"
		)
		const Story := preload(
			"res://resources/saves/v0/collections/story/entities/story.gd",
		)


class Units:
	class Components:
		const Attack := preload(
			"res://resources/saves/v0/collections/units/components/attack.gd"
		)
		const Coordinates := preload(
			"res://resources/saves/v0/collections/units/components/coordinates.gd",
		)
		const Defense := preload(
			"res://resources/saves/v0/collections/units/components/defense.gd",
		)
		const Health := preload(
			"res://resources/saves/v0/collections/units/components/health.gd",
		)
		const Speed := preload(
			"res://resources/saves/v0/collections/units/components/speed.gd",
		)


	class Entities:
		const Ally := preload(
			"res://resources/saves/v0/collections/units/entities/ally.gd",
		)
		const Foe := preload(
			"res://resources/saves/v0/collections/units/entities/foe.gd",
		)
		const Player := preload(
			"res://resources/saves/v0/collections/units/entities/player.gd",
		)
		const Unit := preload(
			"res://resources/saves/v0/collections/units/entities/unit.gd",
		)
