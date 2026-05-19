extends Node3D

@onready var player: Player_Character = $".."
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D
@onready var ray_cast_3d: RayCast3D = $SpringArm3D/Camera3D/RayCast3D

@export_category("Objects")
@export var _spring_arm: SpringArm3D = null

const MOUSE_SENSIBILITY: float = 0.005

#bob variables
const BOB_FREQUENCY = 2.0
const BOB_AMPLITUDE = 0.08

func _ready() -> void:
	player.HeadBob.connect(_on_head_bob)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSIBILITY)
		_spring_arm.rotate_x(-event.relative.y * MOUSE_SENSIBILITY)
		_spring_arm.rotation.x = clamp(_spring_arm.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _on_head_bob(time)->void:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE
	pos.x = sin(time * BOB_FREQUENCY/2) * BOB_AMPLITUDE
	pos.z = _spring_arm.position.z
	_spring_arm.transform.origin = pos
