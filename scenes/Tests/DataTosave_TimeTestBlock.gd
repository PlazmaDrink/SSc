class_name data_to_save_time_test_block

extends data_to_save_custom

const PRELOAD_CUSTOM_TIMETESTBLOCK = preload("uid://bc7cbp1leuoyd")

@export var material: Material

func save_properties(root:Node, custom:Node = null, inIsGlobal = false)->void:
	super.save_properties(root, custom, inIsGlobal)
	material = custom.mesh.get_material()
	
func load_properties(root_node:Node = null, custom_node:Node = null)->void:
	if isGlobal:
		return
	super.load_properties(root_node)
	custom_node.set_material_override(material)

func get_preload()->Resource:
	return PRELOAD_CUSTOM_TIMETESTBLOCK
