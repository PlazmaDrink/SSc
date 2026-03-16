extends SpringArmCharacter

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSIBILITY)
		spring_arm_3d.rotate_x(-event.relative.y * MOUSE_SENSIBILITY)
		spring_arm_3d.rotation.x = clamp(spring_arm_3d.rotation.x, deg_to_rad(-40), deg_to_rad(60))
