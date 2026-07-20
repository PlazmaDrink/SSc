class_name Camera_component
extends Component

@export var spring_arm_3d: SpringArm3D
@export var transitionDuration:float = 1.0;
@onready var transition_camera: Camera3D = $TransitionCamera

func cameraTransition()->void:
	var target_camera = spring_arm_3d.my_camera
	if spring_arm_3d is nonPlayerCamera:
		spring_arm_3d.update_camera_bounds()
	transition_camera.transform = get_viewport().get_camera_3d().transform
	transition_camera.fov = get_viewport().get_camera_3d().fov
	
	transition_camera.make_current()
	var tween:= create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(transition_camera, "global_transform", target_camera.global_transform, transitionDuration)
	tween.tween_property(transition_camera, "fov", target_camera.fov, transitionDuration)
	
	tween.chain().tween_callback(target_camera.make_current)
