class_name Interaction_component
extends Component

##Assign MeshInstance3D of parent, so component can control outline appearence
@export_category("Outline")
@export var target_to_outline: Node3D
@export var OutlineColor: Color = Color.BLACK
@export var OutlineWidth: float = 1
@export var Action_to_do: Interaction

const OUTLINE_SHADER_MATERIAL = preload("uid://d1hbc5mvwhs5")

var local_material_instance: ShaderMaterial
var is_focused:= false
var meshes_to_outline:Array [MeshInstance3D] = []

func initiate_component()->void:
	_prepare_local_material()
	if target_to_outline:
		_gather_all_meshes(target_to_outline)

## Called when the node enters the scene tree for the first time.
func _prepare_local_material():
	local_material_instance = OUTLINE_SHADER_MATERIAL.duplicate()
	local_material_instance.set_shader_parameter("outline_colour", OutlineColor)
	local_material_instance.set_shader_parameter("outline_width", OutlineWidth)
func _gather_all_meshes(target: Node) -> void:
	if target is MeshInstance3D:
		meshes_to_outline.append(target)
	for child in target.get_children():
		_gather_all_meshes(child)

func set_target_to_outline(inTarget: Node)->void:
	target_to_outline = inTarget
	_gather_all_meshes(target_to_outline)

func getOutlineMaterial()->ShaderMaterial:
	return local_material_instance

func raytrace_enter()->void:
	for mesh in meshes_to_outline:
		for surface_idx in range(mesh.mesh.get_surface_count()):
			#var mat = mesh.get_surface_override_material(surface_idx)
			var mat = mesh.get_active_material(surface_idx)
			if mat == null:
				mat = StandardMaterial3D.new()
				mesh.set_surface_override_material(surface_idx, mat)
			mat.next_pass = local_material_instance
	is_focused = true
	
func raytrace_exit()->void:
	for mesh in meshes_to_outline:
		if mesh.mesh == null:
			continue
		for surface_idx in range(mesh.mesh.get_surface_count()):
			var mat = mesh.get_active_material(surface_idx)
			if mat != null:
				mat.next_pass = null
	is_focused = false

func try_interact(func_name:String = "on_interaction")->void:
	if is_focused and Action_to_do:
		Action_to_do.call(func_name, get_parent())
