extends SpringArm3D

@onready var player: Player_Character = $".."
@onready var my_camera: Camera3D = $Camera3D
@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D

const MOUSE_SENSIBILITY: float = 0.005
#headbob variables
const BOB_FREQUENCY = 2.0
const BOB_AMPLITUDE = 0.08

func _ready() -> void:
	CameraManager.camera_changed.connect(on_camera_changed)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation.y -= event.relative.x * MOUSE_SENSIBILITY
		rotation.x -= event.relative.y * MOUSE_SENSIBILITY
		rotation.x = clamp(rotation.x, deg_to_rad(-40), deg_to_rad(60))

func on_camera_changed(_camera:Camera3D)->void:
	player.check_is_current_camera()
