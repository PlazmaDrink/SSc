extends Node


@export var resource_type: DataToSave
@export var root_node_to_save_from: Node
@export var custom_node_to_save_from: Node
@export var isGlobal: bool = false

@export var myResource: DataToSave

func _ready() -> void:
	myResource = resource_type.get_preload().new()
	myResource.isGlobal = isGlobal
	if isGlobal:
		return
	myResource.set_ref_nodes(root_node_to_save_from, custom_node_to_save_from)

func on_save_game(saved_data_globals:Array[DataToSave], saved_data:Array[DataToSave]):
	if not is_multiplayer_authority(): return
	myResource.save_properties()
	if isGlobal:
		saved_data_globals.append(myResource)
	else:
		saved_data.append(myResource)

func on_before_load():
	if not is_multiplayer_authority() or isGlobal: return
	root_node_to_save_from.get_parent().remove_child(root_node_to_save_from)
	queue_free()

func on_load_game(data:DataToSave):
	if not is_multiplayer_authority(): return
	myResource = data
	if not isGlobal:
		myResource.set_ref_nodes(root_node_to_save_from, custom_node_to_save_from)
	myResource.load_properties()
