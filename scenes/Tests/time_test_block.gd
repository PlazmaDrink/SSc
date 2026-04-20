extends Node3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
const NEW = preload("uid://b0sygn7q8ee68")
@onready var component_container: Node = $ComponentContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_time_component_action_finished() -> void:
	mesh_instance_3d.set_material_override(NEW)

#========================SAVE/LOAD SYSTEM============================#
#func on_save_game(saved_data:Array[DataToSave]):
	#if not is_multiplayer_authority(): return
	#var my_data: DataToSave_TimeTestBlock = DataToSave_TimeTestBlock.new()
	#my_data.position = global_position
	#my_data.scene_path = scene_file_path
	#my_data.material = mesh_instance_3d.material_override
	#my_data.parent_path = get_parent().get_path()
	#my_data.index = get_index()
	#saved_data.append(my_data)
#
#func on_before_load():
	#if not is_multiplayer_authority(): return
	#get_parent().remove_child(self)
	#queue_free()
#
#func on_load_game(data:DataToSave_TimeTestBlock):
	#position = data.position
	#if not is_multiplayer_authority(): return
	#mesh_instance_3d.material_override = data.material
#=====================================================================#
