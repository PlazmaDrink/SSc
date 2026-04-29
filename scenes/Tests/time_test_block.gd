extends Node3D

const NEW = preload("uid://b0sygn7q8ee68")

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var my_component_container: component_container = $ComponentContainer

func _on_time_component_action_finished() -> void:
	mesh_instance_3d.set_material_override(NEW)

func get_component_container()->component_container:
	return my_component_container
