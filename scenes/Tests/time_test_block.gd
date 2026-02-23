extends Node3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
const NEW = preload("uid://b0sygn7q8ee68")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_time_component_action_finished() -> void:
	mesh_instance_3d.material_override = NEW
