extends CustomControl
class_name Store_UI

func initiane_UI_element()->void:
	hide()

func toggle_visibility()->void:
	visible = !visible
	if visible:
		show()
		mouse_filter = Control.MOUSE_FILTER_PASS
	else:
		hide()
		get_viewport().set_input_as_handled()

func _on_exit_pressed() -> void:
	var local_player = GlobalData.get_local_player()
	var camera_component = local_player.my_component_container.get_component(GameEnums.Components.CameraComponent)
	camera_component.cameraTransition()
	toggle_visibility()
