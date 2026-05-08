#TODO: Change class_name
class_name ChangeNameToAppropriateOne
extends data_to_save_custom

#TODO: Assigne UID to PRELOAD_CUSTOM!
const PRELOAD_CUSTOM = preload("uid://bxgy60mx22g5x")

func save_properties(root:Node, _custom:Node = null, inIsGlobal = false)->void:
	if isGlobal:
		return
	super.save_properties(root)

func load_properties(root:Node = null, _custom:Node = null)->void:
	if isGlobal:
		return
	super.load_properties(root)

func get_preload()->Resource:
	return PRELOAD_CUSTOM
