extends Node

signal camera_changed(new_camera)

var isPlayerCameraActive:bool = true
var padding: float = 1.0

func switch_camera(new_camera: Camera3D) -> void:
	if new_camera:
		new_camera.make_current()
		camera_changed.emit(new_camera)

func cameraTransition(inTargetSpringArm:SpringArm3D, inTransition_camera:Camera3D, inTransitionDuration:float = 1.0)->void:
	var target_camera = inTargetSpringArm.my_camera
	isPlayerCameraActive = true
	if inTargetSpringArm is store_camera:
		if inTargetSpringArm.target_object:
			var bounds_dict: Dictionary = update_camera_bounds(inTargetSpringArm.target_object)
			inTargetSpringArm.min_bounds = bounds_dict["min_bounds"]
			inTargetSpringArm.max_bounds = bounds_dict["max_bounds"]
		isPlayerCameraActive = false
	inTransition_camera.transform = get_viewport().get_camera_3d().transform
	inTransition_camera.fov = get_viewport().get_camera_3d().fov
	
	inTransition_camera.make_current()
	var tween:= create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(inTransition_camera, "global_transform", target_camera.global_transform, inTransitionDuration)
	tween.tween_property(inTransition_camera, "fov", target_camera.fov, inTransitionDuration)
	
	tween.chain().tween_callback(func():
		target_camera.make_current()
		camera_changed.emit(target_camera)
		)

func update_camera_bounds(inTarget_object: Node3D) -> Dictionary:
	var BoundsDict:Dictionary = {}
	var bounds: AABB = setCameraBounds(inTarget_object)
	
	# Shrink/Expand boundaries using padding
	var min_bounds = bounds.position - Vector3(padding, padding, padding)
	var max_bounds = bounds.end + Vector3(padding, padding, padding)
	BoundsDict["min_bounds"] = min_bounds
	BoundsDict["max_bounds"] = max_bounds
	return BoundsDict

func setCameraBounds(inTarget_object: Node3D)->AABB:
	var combined_aabb := AABB()
	var has_initial_mesh := false
	
	# Recursively find all MeshInstance3D nodes under the target
	var meshes :Array[Node] = inTarget_object.find_children("*", "MeshInstance3D", true, false)
	
	for mesh_node in meshes:
		if mesh_node is MeshInstance3D and mesh_node.visible and mesh_node.mesh:
			# Get local AABB and convert it to world space coordinates
			var world_aabb: AABB = mesh_node.global_transform * mesh_node.get_aabb()
			
			if not has_initial_mesh:
				combined_aabb = world_aabb
				has_initial_mesh = true
			else:
				combined_aabb = combined_aabb.merge(world_aabb)
	return combined_aabb
