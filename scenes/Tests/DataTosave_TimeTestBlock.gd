class_name DataToSave_TimeTestBlock

extends DataToSave

var ref_custom_node:MeshInstance3D

@export var material: Material

func save_properties()->void:
	super.save_properties()
	material = ref_custom_node.get_material_override()
func load_properties()->void:
	super.load_properties()
	ref_custom_node.set_material_override(material)

func set_ref_nodes(inCommonNode, inCustomNode = null)->void:
	super.set_ref_nodes(inCommonNode)
	ref_custom_node = inCustomNode
