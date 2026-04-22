class_name DataToSave_TimeTestBlock

extends DataToSave

const PRELOAD_CUSTOM = preload("uid://bc7cbp1leuoyd")

@export var ref_custom_node:Variant
@export var material: Material

func save_properties()->void:
	super.save_properties()
	material = ref_custom_node.mesh.get_material()
	
func load_properties()->void:
	if isGlobal:
		return
	super.load_properties()
	ref_custom_node.set_material_override(material)

func set_ref_nodes(inCommonNode, inCustomNode = null)->void:
	super.set_ref_nodes(inCommonNode)
	ref_custom_node = inCustomNode

func get_preload()->Resource:
	return PRELOAD_CUSTOM
