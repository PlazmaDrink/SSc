extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
func _on_main_level_pressed() -> void:
	SceneManager.change_scene(SceneManager.game_scenes_dict.get("MainLevel"))
	await SceneManager.scene_loaded


func _on_testing_level_pressed() -> void:
	SceneManager.change_scene(SceneManager.game_scenes_dict.get("TestingLevel"))
	await SceneManager.scene_loaded
