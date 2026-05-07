extends DataToSave

var ref_custom_node:Node

#Assigne UID to PRELOAD_CUSTOM!
const PRELOAD_CUSTOM = preload("uid://csqeytjnduddh")

func save_properties(root:Node, _custom:Node = null, inIsGlobal = false)->void:
	if isGlobal:
		return
	super.save_properties(root)

func load_properties(root:Node, _custom:Node = null)->void:
	if isGlobal:
		return
	super.load_properties(root)

func get_preload()->Resource:
	return PRELOAD_CUSTOM
