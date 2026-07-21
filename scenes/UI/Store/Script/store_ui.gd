extends CustomControl
class_name Store_UI

func initiane_UI_element()->void:
	hide()

func toggle_visibility()->void:
	visible = !visible
	if visible:
		show()
		#await get_tree().process_frame
		#message.grab_focus()
	else:
		hide()
		get_viewport().set_input_as_handled()
