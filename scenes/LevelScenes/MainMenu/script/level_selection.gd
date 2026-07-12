extends Control

signal level_loaded

func _ready()->void:
	hide()

func _on_main_level_pressed() -> void:
	SceneManager.change_scene(SceneManager.game_scenes_dict.get("MainLevel"))
	await SceneManager.scene_loaded
	level_loaded.emit()

func _on_testing_level_pressed() -> void:
	SceneManager.change_scene(SceneManager.game_scenes_dict.get("TestingLevel"))
	await SceneManager.scene_loaded
	level_loaded.emit()
