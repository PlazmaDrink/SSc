extends RayCast3D

const COMPONENT_CONTAINER_TREE_NAME: String = "/ComponentContainer"

##Tracks if raycast hit anything. Required to track when raycast stops heating current object
var rayCastCollisionState: bool = false

var target_collider
var target_component_container

func _input(_event) -> void:
	if is_colliding():
		var collider = get_collider()
		if collider == null: return
		
		if collider.get_parent().is_in_group("iInteractable") && !rayCastCollisionState:
			target_collider = collider
			#Var to track so function call send only once
			rayCastCollisionState = true
			target_component_container = find_target_component_container(collider.get_parent())
			if target_component_container:
				target_component_container.get_component(GameEnums.Components.InteractableComponent).raytrace_enter()
		if target_collider != collider:
			_collision_with_current_object_finished()
	else:
		if rayCastCollisionState:
			_collision_with_current_object_finished()

func find_target_component_container(inTarget_collider)->component_container:
	if inTarget_collider is component_container:
		return inTarget_collider
	for child in inTarget_collider.get_children():
		var target_container = find_target_component_container(child)
		if target_container != null:
			return target_container
	return null

func _collision_with_current_object_finished()->void:
	if target_collider:
		target_component_container.get_component(GameEnums.Components.InteractableComponent).raytrace_exit()
	target_collider = null
	target_component_container = null
	rayCastCollisionState = false

func on_interact_input()->void:
	if target_collider:
		target_component_container.get_component(GameEnums.Components.InteractableComponent).try_interact()
