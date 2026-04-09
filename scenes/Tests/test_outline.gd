extends Node3D

@onready var component_container: Node = $"../ComponentContainer"
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var override_material

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	override_material = StandardMaterial3D.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func raytrace_enter()->void:
	component_container.send_message_to_child("InteractableComponent", "onRayTraceEnter")

func raytrace_exit()->void:
	mesh_instance_3d.get_surface_override_material(0).set_next_pass(null)

func _on_interactable_component_on_ray_trace_enter(shader_material: Variant) -> void:
	mesh_instance_3d.get_surface_override_material(0).next_pass = shader_material
