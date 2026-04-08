extends Node3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_interactable_component_on_ray_trace_enter(shader: Variant) -> void:
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	var override_material = StandardMaterial3D.new()
	mesh_instance_3d.set_surface_override_material(0, override_material)
	mesh_instance_3d.get_surface_override_material(0).next_pass = shader_material


func _on_interactable_component_on_ray_trace_exit() -> void:
	pass # Replace with function body.
