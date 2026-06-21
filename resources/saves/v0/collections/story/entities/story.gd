extends PersistedV0

@export_group("Chapters")
@export var chapters: Array[SaveSchemaV0.UseStory.Entities.Chapter] = []
@export var current_chapter: SaveSchemaV0.UseStory.Entities.Chapter = (
	SaveSchemaV0.UseStory.Entities.Chapter.NullChapter.new()
)
