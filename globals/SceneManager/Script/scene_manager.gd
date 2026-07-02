extends Node

var current_scene = null

signal scene_loaded

var game_scenes_dict = {
	"MainMenu": "res://scenes/LevelScenes/MainMenu/scene/main_menu_ui.tscn",
	"MainLevel": "res://scenes/LevelScenes/MainLevel/scene/level.tscn",
	"LevelSelection": "res://scenes/LevelScenes/MainMenu/scene/levelSelection.tscn",
	"TestingLevel": "res://scenes/LevelScenes/Testing Level/TestingLevel.tscn",
	"GlobalData": "res://globals/GlobalData/Scene/GlobalData.tscn",
	"GlobalTime": "res://globals/TimeManager/Scene/global_time.tscn",
	"player":"res://scenes/characters/Player/Scene/player.tscn",
	"test_outline":"res://scenes/Tests/test_outline.tscn",
	"ui_manager":"res://scenes/UI/UI_Manager/Scene/ui_manager.tscn"
}

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func change_scene(path: String):
	call_deferred("_deferred_change_scene", path)

func _deferred_change_scene(path):
	if current_scene:
		current_scene.free()

	var new_scene = load(path).instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	current_scene = new_scene
	scene_loaded.emit()
