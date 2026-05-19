extends RayCast3D

const COMPONENT_CONTAINER_TREE_NAME: String = "/ComponentContainer"

##Tracks if raycast hit anything. Required to track when raycast stops heating current object
var rayCastCollisionState: bool = false

var target_collider
var target_component_container

func _input(_event) -> void:
	if is_colliding():
		#Condition makes sure function call send only once
		var collider = get_collider()
		if collider == null:
			return
		if collider.get_parent().is_in_group("iInteractable") && !rayCastCollisionState:
			rayCastCollisionState = true
			target_collider = collider
			var path:String = target_collider.get_parent().get_path()
			target_component_container = get_node(path + COMPONENT_CONTAINER_TREE_NAME)
			target_component_container.get_component(GameEnums.Components.InteractableComponent).raytrace_enter()
		if target_collider != collider:
			_collision_with_current_object_finished()
	else:
		if rayCastCollisionState:
			_collision_with_current_object_finished()
	print_debug(target_collider)

func _collision_with_current_object_finished()->void:
	if target_collider:
		target_component_container.get_component(GameEnums.Components.InteractableComponent).raytrace_exit()
	target_collider = null
	target_component_container = null
	rayCastCollisionState = false
