class_name Interaction_CameraMode
extends Interaction

func on_interaction(_componentContainer: component_container):
	var local_player:Player_Character = GlobalData.get_local_player()
	var camera_component:Camera_component = _componentContainer.get_component(GameEnums.Components.CameraComponent)
	if camera_component:
		camera_component.cameraTransition()
		#requestUIupdate
		local_player.game_state.getUI_manager().store_ui.toggle_visibility()
