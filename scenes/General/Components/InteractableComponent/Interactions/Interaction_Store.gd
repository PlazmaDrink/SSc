class_name Interaction_Store
extends Interaction

var local_player:Player_Character = null

func on_interaction(_componentContainer: component_container):
	check_player()
	handle_camera(_componentContainer)
	link_UI_with_store(_componentContainer)

func handle_camera(_componentContainer: component_container):
	var camera_component:Camera_component = _componentContainer.get_component(GameEnums.Components.CameraComponent)
	if camera_component:
		camera_component.cameraTransition()
		#requestUIupdate
		local_player.game_state.getUI_manager().store_ui.toggle_visibility()

func link_UI_with_store(_componentContainer: component_container):
	var store_ref = find_store_node(_componentContainer)
	local_player.game_state.getUI_manager().store_ui.store_ref = store_ref

func check_player()->void:
	if local_player == null:
		local_player = GlobalData.get_local_player()

func find_store_node(node: Node) -> Node:
	var parent = node.get_parent()
	# Base case 1: Reached the top of the tree
	if parent == null:
		return null
	# Base case 2: Found a parent matching the type
	if is_instance_of(parent, StoreTemplate):
		return parent
	# Recursive step: Keep checking up the chain
	return find_store_node(parent)
