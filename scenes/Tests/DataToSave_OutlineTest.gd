class_name DataToSave_OutlineTest

extends DataToSave_Custom

var ref_custom_node:Node
var inventory_content: Dictionary

#Assigne UID to PRELOAD_CUSTOM!
const PRELOAD_CUSTOM = preload("uid://dry3eod5i7wv7")

func save_properties(root:Node, _custom:Node = null, inIsGlobal = false)->void:
	if isGlobal:
		return
	super.save_properties(root)
	inventory_content = _custom.get_component(GameEnums.Components.InventoryComponent).get_inventory().to_dict()

func load_properties(root:Node = null, _custom:Node = null)->void:
	if isGlobal:
		return
	super.load_properties(root)
	_custom.get_component(GameEnums.Components.InventoryComponent).get_inventory().from_dict(inventory_content)

func get_preload()->Resource:
	return PRELOAD_CUSTOM
