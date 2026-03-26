extends Node

var current_scene = null


var game_scenes_dict = {
	"MainMenu": "res://scenes/LevelScenes/MainMenu/scene/main_menu_ui.tscn",
	"MainLevel": "res://scenes/LevelScenes/MainLevel/scene/level.tscn"
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
