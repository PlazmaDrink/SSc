extends Component
class_name Preview_component

@export var valid_mat:StandardMaterial3D
@export var invalid_mat:StandardMaterial3D
@export var normal_mat:StandardMaterial3D

@export var target_node: Node3D
var meshes_to_prieviw:Array[MeshInstance3D]
var area_to_track:Area3D

var is_following_mouse := true
@onready var camera: Camera3D = get_viewport().get_camera_3d()

func _physics_process(_delta: float) -> void:
	if not is_following_mouse or not camera:
		return
		
	# 1. Get 2D mouse position on the screen
	var mouse_pos = get_viewport().get_mouse_position()
	
	# 2. Project a ray from the camera into 3D space
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_normal = camera.project_ray_normal(mouse_pos)
	
	# 3. Create a virtual flat ground plane (facing UP at Y-height 0)
	var ground_plane = Plane(Vector3.UP, 0.0)
	
	# 4. Find where the camera ray hits the ground plane
	var intersection = ground_plane.intersects_ray(ray_origin, ray_normal)
	
	if intersection != null:
		area_to_track.global_position = intersection

func set_Target_node(inTargetNode:Node)->void:
	target_node = inTargetNode
	
func initiate_component()->void:
	if target_node:
		_gather_all_meshes(target_node)
		find_area_to_track(target_node)
		check_required_material()
	else:
		print_debug("No target node selected")

func _gather_all_meshes(target: Node) -> void:
	if target is MeshInstance3D:
		meshes_to_prieviw.append(target)
	for child in target.get_children():
		_gather_all_meshes(child)

func find_area_to_track(target: Node)->void:
	if target is Area3D:
		area_to_track = target
	for child in target.get_children():
		find_area_to_track(child)
	#if area_to_track:
		#connect_to_area()

func connect_to_area():
	area_to_track.area_entered.connect(check_required_material)
	area_to_track.area_exited.connect(check_required_material)

func check_required_material():
	var final_material:StandardMaterial3D
	if area_to_track and area_to_track.has_overlapping_areas():
		final_material = invalid_mat
	else:
		final_material = valid_mat
	for mesh in meshes_to_prieviw:
		for surface_idx in range(mesh.mesh.get_surface_count()):
			var mat = mesh.get_surface_override_material(surface_idx)
			if mat == null:
				mat = StandardMaterial3D.new()
				mesh.set_surface_override_material(surface_idx, mat)
			mat.next_pass = final_material

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
