class_name data_to_save_outline_test
extends data_to_save_custom

var custom_scene_path:String = "res://scenes/Tests/test_outline.tscn"

const PRELOAD_CUSTOM = preload("uid://ci5jqf3fynvq7")

@export var inventory_dict:Dictionary = {}

func save_properties(root:Node, _custom:Node = null, inIsGlobal = false)->void:
	if inIsGlobal:
		return
	super.save_properties(root)
	scene_path = custom_scene_path
	inventory_dict = _custom.get_component(GameEnums.Components.InventoryComponent).get_inventory().to_dict()
	pass

func load_properties(root:Node = null, _custom:Node = null)->void:
	if isGlobal:
		return
	super.load_properties(root)
	if inventory_dict != {}:
		_custom.get_component(GameEnums.Components.InventoryComponent).get_inventory().from_dict(inventory_dict)
	pass

func get_preload()->Resource:
	return PRELOAD_CUSTOM
