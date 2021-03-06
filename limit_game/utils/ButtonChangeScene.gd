class_name ChangeScene
extends ButtonSFX

export(String, FILE, "*.tscn") var next_scene


func _ready() -> void:
	if OS.is_debug_build():
		var file = File.new()
		assert(file.file_exists(next_scene), "next_scene is not a valid file path." +
				"\nPlease set the next_scene property for this button.\n" + get_path())


# Changes scene to next_scene
func _pressed() -> void:
	SceneHandler.goto_scene(next_scene)
	._pressed()
