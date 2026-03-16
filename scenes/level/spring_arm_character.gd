extends SpringArmCharacter

@onready var player: Character = $".."
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D

#bob variables
const BOB_FREQUENCY = 2.0
const BOB_AMPLITUDE = 0.08

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.HeadBob.connect(_on_head_bob)
	
func _input(event) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSIBILITY)
		spring_arm_3d.rotate_x(-event.relative.y * MOUSE_SENSIBILITY)
		spring_arm_3d.rotation.x = clamp(spring_arm_3d.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _on_head_bob(time)->void:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE
	pos.x = sin(time * BOB_FREQUENCY/2) * BOB_AMPLITUDE
	pos.z = spring_arm_3d.position.z
	spring_arm_3d.transform.origin = pos
	print(pos)
