extends Node

signal camera_changed(new_camera)

var isPlayerCameraActive:bool = true
func switch_camera(new_camera: Camera3D) -> void:
	if new_camera:
		new_camera.make_current()
		camera_changed.emit(new_camera)

func cameraTransition(inTargetSpringArm:SpringArm3D, inTransition_camera:Camera3D, inTransitionDuration:float = 1.0)->void:
	var target_camera = inTargetSpringArm.my_camera
	isPlayerCameraActive = true
	if inTargetSpringArm is nonPlayerCamera:
		inTargetSpringArm.update_camera_bounds()
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
