extends Component
class_name Preview_component

@export var valid_mat:StandardMaterial3D
@export var invalid_mat:StandardMaterial3D
var mesh_origin_material_dict:Dictionary = {}

@export var target_node: Node3D
var area_to_track:Area3D

@onready var camera: Camera3D = get_viewport().get_camera_3d()
var isOverlapping:bool = false

var min_bounds:Vector3
var max_bounds:Vector3

##If false - ignore input
#TODO:implement isCurrentlySelected
var isCurrentlySelected:bool = false

func initiate_component()->void:
	target_node = my_component_container.root_node
	if target_node:
		_gather_all_meshes(target_node)
		find_area_to_track(target_node)
		check_required_material()
	else:
		print_debug("No target node selected")

#TODO: bounds need to take in count size of item itself
func set_preview_bonds(BoundsDict:Dictionary)->void:
	min_bounds = BoundsDict["min_bounds"]
	max_bounds = BoundsDict["max_bounds"]
	
func set_Target_node(inTargetNode:Node)->void:
	target_node = inTargetNode

func _physics_process(_delta: float) -> void:
	if not camera:
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
		intersection.x = clamp(intersection.x, min_bounds.x, max_bounds.x)
		intersection.z = clamp(intersection.z, min_bounds.z, max_bounds.z)
		target_node.global_position = intersection

##Collects model meshes and origin materials
func _gather_all_meshes(target_mesh: Node) -> void:
	if target_mesh is MeshInstance3D:
		#Loop to get all materials on the selected mesh
		var temp_array_mat = []
		for surface_idx in range(target_mesh.mesh.get_surface_count()):
			temp_array_mat.append(target_mesh.get_surface_override_material(surface_idx))
		mesh_origin_material_dict[target_mesh] = temp_array_mat
	for child in target_mesh.get_children():
		_gather_all_meshes(child)

func set_origin_mat_to_mesh()->void:
	for mesh_instance in mesh_origin_material_dict.keys():
		if is_instance_valid(mesh_instance):
			var saved_materials = mesh_origin_material_dict[mesh_instance]
			# Loop through the saved array and apply the materials back
			for surface_idx in range(saved_materials.size()):
				var mat = saved_materials[surface_idx]
				mesh_instance.set_surface_override_material(surface_idx, mat)

func find_area_to_track(target: Node)->void:
	if target is Area3D:
		area_to_track = target
	else:
		for child in target.get_children():
			find_area_to_track(child)
	if area_to_track:
		connect_to_area()

func connect_to_area():
	if not area_to_track.area_entered.is_connected(check_required_material) and not area_to_track.body_entered.is_connected(check_required_material):
		area_to_track.area_entered.connect(check_required_material)
		area_to_track.body_entered.connect(check_required_material)
	if not area_to_track.area_exited.is_connected(check_required_material)and not area_to_track.body_exited.is_connected(check_required_material):
		area_to_track.area_exited.connect(check_required_material)
		area_to_track.body_exited.connect(check_required_material)

func check_required_material(_area: CollisionObject3D = null):
	if not is_inside_tree():
		return
	await get_tree().physics_frame
	var final_material:StandardMaterial3D
	isOverlapping = area_to_track.has_overlapping_areas() or area_to_track.has_overlapping_bodies()
	if area_to_track:
		if isOverlapping:
			final_material = invalid_mat
			target_node.set_canBePlaced(false)
		else:
			final_material = valid_mat
			target_node.set_canBePlaced(true)
	for mesh in mesh_origin_material_dict.keys():
		for surface_idx in range(mesh.mesh.get_surface_count()):
			mesh.set_surface_override_material(surface_idx, final_material)

func update_process_node(input:Node.ProcessMode)->void:
	process_mode = input
	
