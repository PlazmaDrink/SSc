class_name DataToSave
extends Resource

# In order to save/load data:
# Parent has to have implemented 3 functions:
# func on_save_game(saved_data:Array[DataToSave]):
# func on_before_load():
# func on_load_game(data:DataToSave):
# If some object specific data required - create new script that inherits from DataToSave
# All vars have to be @export

var ref_root_node:Node

@export var position:Vector3
@export var scene_path:String
@export var parent_path:String
@export var index: int

func save_properties()->void:
	position = ref_root_node.position
	scene_path = ref_root_node.scene_file_path
	parent_path = ref_root_node.get_parent().get_path()
	index = ref_root_node.get_index()

func load_properties()->void:
	ref_root_node.position = position

func set_ref_nodes(inCommonNode, inCustomNode = null)->void:
	ref_root_node = inCommonNode
