class_name Interaction_CameraMode
extends Interaction

func on_interaction(_componentContainer: component_container):
	var camera_component:Camera_component = _componentContainer.get_component(GameEnums.Components.CameraComponent)
	if camera_component:
		camera_component.cameraTransition()
		#Turns off player movement
		GlobalData.get_local_player().check_is_current_camera()
