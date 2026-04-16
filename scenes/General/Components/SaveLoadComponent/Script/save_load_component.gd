extends Node


@export var resource_type: Resource
@export var common_node_to_save_from: Node
@export var custom_node_to_save_from: Node

var myResource: Resource

func _ready() -> void:
	myResource = resource_type.new()
	myResource.set_ref_node(common_node_to_save_from, custom_node_to_save_from)

func on_save_game(saved_data:Array[DataToSave]):
	if not is_multiplayer_authority(): return
	if custom_node_to_save_from:
		myResource.save_properties()
	else:
		myResource.save_properties()
	saved_data.append(myResource)

func on_before_load():
	if not is_multiplayer_authority(): return
	get_parent().remove_child(self)
	queue_free()

func on_load_game(data:DataToSave_TimeTestBlock):
	if not is_multiplayer_authority(): return
	myResource = data
	data.load_properties()
