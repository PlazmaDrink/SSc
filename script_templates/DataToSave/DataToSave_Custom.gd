extends DataToSave

var ref_custom_node:Node

#Assigne UID to PRELOAD_CUSTOM!
const PRELOAD_CUSTOM = preload("uid://csqeytjnduddh")

func save_properties()->void:
	if isGlobal:
		return
	super.save_properties()

func load_properties()->void:
	if isGlobal:
		return
	super.load_properties()

func set_ref_nodes(inCommonNode, inCustomNode = null)->void:
	super.set_ref_nodes(inCommonNode)
	ref_custom_node = inCustomNode

func get_preload()->Resource:
	return PRELOAD_CUSTOM
