extends Node


@export var resource_type: Resource
@export var root_node_to_save_from: Node
@export var custom_node_to_save_from: Node
@export var isDestroyedOnPreload: bool = true

var myResource: Resource

func _ready() -> void:
	myResource = resource_type.new()
	myResource.set_ref_nodes(root_node_to_save_from, custom_node_to_save_from)

func on_save_game(saved_data:Array[DataToSave]):
	if not is_multiplayer_authority(): return
	myResource.save_properties()
	saved_data.append(myResource)

func on_before_load():
	if not is_multiplayer_authority() && not isDestroyedOnPreload: return
	root_node_to_save_from.get_parent().remove_child(root_node_to_save_from)
	queue_free()

func on_load_game(data:DataToSave):
	if not is_multiplayer_authority(): return
	myResource = data
	if isDestroyedOnPreload:
		myResource.set_ref_nodes(root_node_to_save_from, custom_node_to_save_from)
		myResource.load_properties()
