class_name DataToSave
extends Resource

# In order to save/load data:
# Parent has to have implemented 3 functions:
# func on_save_game(saved_data:Array[DataToSave]):
# func on_before_load():
# func on_load_game(data:DataToSave):
# If some object specific data required - create new script that inherits from DataToSave
# All vars have to be @export

var ref_common_node:Node

@export var position:Vector3
@export var scene_path:String
@export var parent_path:String
@export var index: int

func save_properties()->void:
	position = ref_common_node.position
	scene_path = ref_common_node.get_path()
	parent_path = ref_common_node.get_parent().get_path()
	index = ref_common_node.get_index()

func load_properties()->void:
	ref_common_node.position = position

func set_ref_node(inCommonNode, inCustomNode = null)->void:
	ref_common_node = inCommonNode
