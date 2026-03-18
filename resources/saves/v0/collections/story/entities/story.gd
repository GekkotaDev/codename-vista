extends PersistedV0

@export_group("Chapters")
@export var chapters: Array[SaveSchemaV0.Story.Entities.Chapter] = []
@export var current_chapter: SaveSchemaV0.Story.Entities.Chapter = (
	SaveSchemaV0.Story.Entities.Chapter.NullChapter.new()
)
