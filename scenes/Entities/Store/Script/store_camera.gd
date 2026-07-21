class_name nonPlayerCamera
extends SpringArm3D

@onready var my_camera: Camera3D = $myCamera

@export var move_speed: float = 10.0

@export_group("Orbit Settings")
@export var mouse_sensitivity: float = 0.003

@export_group("Zoom Settings")
@export var zoom_step: float = 0.5
@export var min_distance: float = -5
@export var max_distance: float = 5

@export_group("Camera Boundaries")
@export var target_object: Node3D
@export var padding: float = 1.0
var min_bounds: Vector3
var max_bounds: Vector3

func _unhandled_input(event: InputEvent) -> void:
	if my_camera.current:
		# 1. Orbit camera on Right Click + Drag
		if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			rotation.y -= event.relative.x * mouse_sensitivity
			rotation.x -= event.relative.y * mouse_sensitivity
			# Clamp pitch angle so camera doesn't flip upside down
			rotation.x = clamp(rotation.x, deg_to_rad(-80.0), deg_to_rad(80.0))

		# 2. Zoom in/out by adjusting the spring length
		if event is InputEventMouseButton and event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				spring_length -= zoom_step
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				spring_length += zoom_step
			
			spring_length = clamp(spring_length, min_distance, max_distance)

func _process(_delta: float) -> void:
	if my_camera.current:
		handle_input_movement(_delta)

func handle_input_movement(delta:float)->void:
	var direction := Input.get_vector(
			"move_left", "move_right",
			"move_forward", "move_backward"
			)
		#Rotate the local direction vector relative to the camera's rotation
	var _direction: Vector3 = transform.basis * Vector3(direction.x, 0, direction.y)
	#Flatten Y
	_direction.y = 0
	global_position += _direction * move_speed * delta
	
	# Clamp camera target position within object bounds
	global_position.x = clamp(global_position.x, min_bounds.x, max_bounds.x)
	global_position.z = clamp(global_position.z, min_bounds.z, max_bounds.z)

func update_camera_bounds() -> void:
	var bounds: AABB = setCameraBounds(target_object)
	
	# Shrink/Expand boundaries using padding
	min_bounds = bounds.position - Vector3(padding, padding, padding)
	max_bounds = bounds.end + Vector3(padding, padding, padding)

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
