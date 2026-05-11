extends Node

#Choose resource file to write save data in (If requirs unique data, create new script based ob DataToSave_Custom
@export var resource_type: data_to_save
#This node will be used to save data from and load to
@export var custom_node_to_save_from: Node
@export var isGlobal: bool = false
@export var root_node_to_save_from: Node

@export var myResource: data_to_save

func _ready() -> void:
	myResource = resource_type.get_preload().new()
func on_save_game(saved_data_globals:Array[data_to_save_custom], saved_data:Array[data_to_save]):
	if not is_multiplayer_authority(): return
	myResource.save_properties(root_node_to_save_from, custom_node_to_save_from, isGlobal)
	if isGlobal:
		saved_data_globals.append(myResource)
	else:
		saved_data.append(myResource)

func on_before_load():
	if not is_multiplayer_authority() or isGlobal: return
	root_node_to_save_from.get_parent().remove_child(root_node_to_save_from)
	queue_free()

func on_load_game(data:data_to_save):
	if not is_multiplayer_authority(): return
	myResource = data
	myResource.load_properties(root_node_to_save_from, custom_node_to_save_from)
