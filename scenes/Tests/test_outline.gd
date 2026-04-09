extends Node3D

@onready var component_container: Node = $"../ComponentContainer"
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var outlineMaterial: ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	outlineMaterial = component_container.get_component("InteractableComponent").getOutlineMaterial()

func raytrace_enter()->void:
	mesh_instance_3d.get_surface_override_material(0).next_pass = outlineMaterial
	
func raytrace_exit()->void:
	mesh_instance_3d.get_surface_override_material(0).set_next_pass(null)
