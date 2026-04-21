extends Node

const GROUP_NAME = "DataToSave"
const FUNC_SAVE_GAME = "on_save_game"
const FUNC_BEFORE_LOAD = "on_before_load"
const FUNC_LOAD_GAME = "on_load_game"
const SAVE_FILES_FOLDER_PATH = "res://SaveFiles/"
const SAVE_FILE_FORMAT = ".tres"

@onready var level: Node = $"."

var name_to_path_dict = {}
var save_location:String = ""

func save_game(save_name = "DefaultSaveFile"):
	if multiplayer.is_server():
		# Add save file name and path to local dictionary
		var temp_key:String = save_name
		var temp_value = SAVE_FILES_FOLDER_PATH + save_name + SAVE_FILE_FORMAT
		name_to_path_dict.set(temp_key, temp_value)
		save_location = temp_value
		
		# Collect dataToSave from all items in "DataToSave" group
		var saved_data_globals:Array[DataToSave] = []
		var saved_data:Array[DataToSave] = []
		get_tree().call_group(GROUP_NAME, FUNC_SAVE_GAME, saved_data_globals, saved_data)
		
		# Create a saveGame file and assign var values
		var saved_game: SavedGame = SavedGame.new()
		saved_game.saved_data_globals = saved_data_globals
		saved_game.saved_data = saved_data
		
		#Save the game
		ResourceSaver.save(saved_game, save_location)

func load_game(load_name = "DefaultSaveFile"):
	if multiplayer.is_server():
		var saved_game: SavedGame = load(name_to_path_dict.get(load_name)) as SavedGame
		get_tree().call_group(GROUP_NAME, FUNC_BEFORE_LOAD)
		_update_globals(saved_game.saved_data_globals)
		for item in saved_game.saved_data:
			item.ref_root_node.component_container.get_component("SaveLoadComponent").on_load_game(item)
			var scene = load(item.scene_path) as PackedScene
			var restored_node = scene.instantiate()
			if(item.parent_path):
				get_node(item.parent_path).add_child(restored_node)
				if(item.index):
					get_node(item.parent_path).move_child(restored_node, item.index)
			restored_node.component_container.get_component("SaveLoadComponent").on_load_game(item)

func update_name_to_path_dict() -> void:
	if multiplayer.is_server():
		var dir = DirAccess.open(SAVE_FILES_FOLDER_PATH)
		if dir == null:
			print("Failed to open directory")
			return
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			name_to_path_dict.set(file_name.rstrip("."), SAVE_FILES_FOLDER_PATH + file_name)
			file_name = dir.get_next()

		dir.list_dir_end()

func _update_globals(savedData: Array[DataToSave]):
	for item in savedData:
		item.load_properties()
