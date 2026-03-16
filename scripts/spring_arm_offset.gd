extends Node3D
class_name SpringArmCharacter

const MOUSE_SENSIBILITY: float = 0.005

@export_category("Objects")
@export var _spring_arm: SpringArm3D = null
@onready var spring_arm_3d: SpringArm3D = $SpringArm3D

var input_rotation: Vector3
var mouse_input: Vector2

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSIBILITY)
		spring_arm_3d.rotate_x(-event.relative.y * MOUSE_SENSIBILITY)
		spring_arm_3d.rotation.x = clamp(spring_arm_3d.rotation.x, deg_to_rad(-40), deg_to_rad(60))

#func _unhandled_input(_event) -> void:
	#if (_event is InputEventMouseMotion) and is_multiplayer_authority():
		#rotate_y(-_event.relative.x * MOUSE_SENSIBILITY)
		#_spring_arm.rotate_x(-_event.relative.y * MOUSE_SENSIBILITY)
		#_spring_arm.rotation.x = clamp(_spring_arm.rotation.x, -PI/4, PI/24)
