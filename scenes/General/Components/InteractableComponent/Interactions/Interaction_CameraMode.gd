class_name Interaction_CameraMode
extends Interaction

func on_interaction(_componentContainer: component_container):
	var camera_component:Camera_component = _componentContainer.get_component(GameEnums.Components.CameraComponent)
	if camera_component:
		camera_component.cameraTransition()
