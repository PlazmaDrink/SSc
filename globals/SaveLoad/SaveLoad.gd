extends Node

const SAVE_LOCATION = "res://SaveFiles/SaveFile.tres"
const GROUP_NAME = "DataToSave"
const FUNC_SAVE_GAME = "on_save_game"
const FUNC_BEFORE_LOAD = "on_before_load"
const FUNC_LOAD_GAME = "on_load_game"
@onready var level: Node = $"."

func save_game():
	var saved_game: SavedGame = SavedGame.new()
	var saved_data:Array[DataToSaveResource] = []
	get_tree().call_group(GROUP_NAME, FUNC_SAVE_GAME, saved_data)
	saved_game.saved_data = saved_data
	ResourceSaver.save(saved_game, SAVE_LOCATION)

func load_game():
	var saved_game: SavedGame = load(SAVE_LOCATION) as SavedGame
	get_tree().call_group(GROUP_NAME, FUNC_BEFORE_LOAD)

	for item in saved_game.saved_data:
		var scene = load(item.scene_path) as PackedScene
		var restored_node = scene.instantiate()
		level.add_child(restored_node)
		
		if restored_node.has_method(FUNC_LOAD_GAME):
			restored_node.on_load_game(item)
