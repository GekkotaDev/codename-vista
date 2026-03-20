extends PersistedV0

const Class := preload("./chapter.gd")

@export var chapter_id: String = ""
@export var flags: Dictionary[String, SaveSchemaV0.UseFlags.Components.Flag] = { }


class NullChapter extends Class:
	pass
