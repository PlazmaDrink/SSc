class_name DataToSave_TimeTestBlock

extends DataToSave

var ref_custom_node:Node

@export var material: Material

func save_properties()->void:
	super.save_properties()
	material = ref_custom_node.material_override

func load_properties()->void:
	super.load_properties()
	ref_custom_node.material_override = material

func set_ref_node(inCommonNode, inCustomNode = null)->void:
	super.set_ref_node(inCommonNode)
	ref_custom_node = inCustomNode
