class_name SaveSchemaV0

const _SAVES = "res://resources/saves/v0/collections"


class UseFlags:
	class Components:
		const Flag := preload(
			"res://resources/saves/v0/collections/flags/components/flag.gd"
		)


class UseParty:
	class Entities:
		const Party := preload(
			"res://resources/saves/v0/collections/party/entities/party.gd"
		)


class UseRoom:
	class Entities:
		const Room := preload(
			"res://resources/saves/v0/collections/room/entities/room.gd"
		)


class UseStorage:
	class Components:
		const Target := preload(
			"res://resources/saves/v0/collections/storage/components/target.gd"
		)


	class Entities:
		class Containers:
			const Containers := preload(
				"res://resources/saves/v0/collections/storage/entities/containers/container.gd"
			)


		class Items:
			const Consumable := preload(
				"res://resources/saves/v0/collections/storage/entities/items/consumable.gd"
			)

			const Gear := preload(
				"res://resources/saves/v0/collections/storage/entities/items/gear.gd"
			)

			const Item := preload(
				"res://resources/saves/v0/collections/storage/entities/items/item.gd"
			)

			const Key := preload(
				"res://resources/saves/v0/collections/storage/entities/items/key.gd"
			)


class UseStory:
	class Entities:
		const Chapter := preload(
			"res://resources/saves/v0/collections/story/entities/chapter.gd"
		)
		const Story := preload(
			"res://resources/saves/v0/collections/story/entities/story.gd"
		)


class UseUnits:
	class Components:
		const Attack := preload(
			"res://resources/saves/v0/collections/units/components/attack.gd"
		)
		const Coordinates := preload(
			"res://resources/saves/v0/collections/units/components/coordinates.gd"
		)
		const Defense := preload(
			"res://resources/saves/v0/collections/units/components/defense.gd"
		)
		const Health := preload(
			"res://resources/saves/v0/collections/units/components/health.gd"
		)
		const Speed := preload(
			"res://resources/saves/v0/collections/units/components/speed.gd"
		)


	class Entities:
		const Ally := preload(
			"res://resources/saves/v0/collections/units/entities/ally.gd"
		)
		const Foe := preload(
			"res://resources/saves/v0/collections/units/entities/foe.gd"
		)
		const Player := preload(
			"res://resources/saves/v0/collections/units/entities/player.gd"
		)
		const Unit := preload(
			"res://resources/saves/v0/collections/units/entities/unit.gd"
		)
