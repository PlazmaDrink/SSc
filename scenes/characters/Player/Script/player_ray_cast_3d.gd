extends RayCast3D

const COMPONENT_CONTAINER_TREE_NAME: String = "/ComponentContainer"

##Tracks if raycast hit anything. Required to track when raycast stops heating current object
var rayCastCollisionState: bool = false

var target_collider
var target_component_container

func _input(event) -> void:
	if is_colliding():
		#Condition makes sure function call send only once
		if get_collider().is_in_group("iInteractable") && !rayCastCollisionState:
			rayCastCollisionState = true
			target_collider = get_collider()
			var path:String = target_collider.get_parent().get_path()
			target_component_container = get_node(path + COMPONENT_CONTAINER_TREE_NAME)
			target_component_container.get_component("InteractableComponent").call("raytrace_enter")
	else:
		if rayCastCollisionState:
			target_component_container.get_component("InteractableComponent").call("raytrace_exit")
			target_collider = null
			target_component_container = null
			rayCastCollisionState = false
