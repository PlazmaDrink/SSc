extends RayCast3D

var current_collider: Node = null
var current_container: component_container = null

func _physics_process(_delta: float) -> void:
	var new_collider = get_collider() if is_colliding() else null
	
	# Only update states if the object we are looking at has changed
	if new_collider != current_collider:
		_change_target(new_collider)

func _change_target(new_collider: Node) -> void:
	# 1. CLEANUP PREVIOUS TARGET: If we had a previous interactable, trigger exit
	if current_container:
		var interactable = current_container.get_component(GameEnums.Components.InteractableComponent)
		if interactable:
			interactable.raytrace_exit()
	# 2. UPDATE TRACKERS
	current_collider = new_collider
	current_container = null
	
	# 3. INITIALIZE NEW TARGET: If we are looking at a new object, trigger enter
	if current_collider:
		var interactable_root = _get_interactable_root(current_collider)
		
		# Ensure it exists and is interactable before searching the tree
		if interactable_root:
			current_container = _find_component_container(interactable_root)
			
			if current_container:
				var interactable = current_container.get_component(GameEnums.Components.InteractableComponent)
				if interactable:
					interactable.raytrace_enter()

func _get_interactable_root(node: Node) -> Node:
	var current_node = node
	while current_node != null:
		if current_node.is_in_group("iInteractable"):
			return current_node
		current_node = current_node.get_parent()
	return null

## Recursively searches the given node and all its children for a component_container
func _find_component_container(node: Node) -> component_container:
	# Base case: we found it
	if node is component_container:
		return node
		
	# Recursive case: search through all children
	for child in node.get_children():
		var found_container = _find_component_container(child)
		if found_container != null:
			return found_container
			
	# If not found in this branch
	return null

## Called externally (e.g., from an Input map action in your Player script)
func on_interact_input() -> void:
	if current_container:
		var interactable = current_container.get_component(GameEnums.Components.InteractableComponent)
		if interactable:
			interactable.try_interact()
