class_name Camera_component
extends Component

@export var spring_arm_3d: SpringArm3D
@export var transitionDuration:float = 1.0;
@onready var transition_camera: Camera3D = $TransitionCamera

func cameraTransition()->void:
	CameraManager.cameraTransition(spring_arm_3d, transition_camera, transitionDuration)
