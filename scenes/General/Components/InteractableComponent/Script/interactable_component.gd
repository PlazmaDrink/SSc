extends Node


##Assign MeshInstance3D of parent, so component can control outline appearence
@export_category("Outline")
@export var meshToOutline: MeshInstance3D
@export var outlineMaterial: ShaderMaterial
@export var OutlineColor: Color = Color.TRANSPARENT
@export var OutlineWidth: float = 0.0

var local_material_instance: ShaderMaterial

func _ready() -> void:
	local_material_instance = outlineMaterial.duplicate()
	local_material_instance.set_shader_parameter("outline_colour", OutlineColor)
	local_material_instance.set_shader_parameter("outline_width", OutlineWidth)

## Called when the node enters the scene tree for the first time.
func getOutlineMaterial()->ShaderMaterial:
	return outlineMaterial

func raytrace_enter()->void:
	if meshToOutline.get_surface_override_material(0) == null:
		meshToOutline.set_surface_override_material(0, StandardMaterial3D.new())
	meshToOutline.get_surface_override_material(0).next_pass = local_material_instance
	
func raytrace_exit()->void:
	meshToOutline.get_surface_override_material(0).set_next_pass(null)
