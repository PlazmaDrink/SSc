extends CustomControl
class_name UI_Debug

@onready var ui_time_control: UI_Time_Control = $SubMenus/UI_TimeControl
@onready var ui_save_load: UI_Save_Load_Menu = $SubMenus/UI_Save_Load
@onready var main_container: VBoxContainer = $ColorRect/MainContainer

# Called when the node enters the scene tree for the first time.
func initiane_UI_element() -> void:
	ui_time_control.hide()
	ui_time_control.on_Close.connect(_on_submenu_toggle)
	ui_save_load.on_Close.connect(_on_submenu_toggle)
	ui_save_load.on_Pop_up_request.connect(_on_pop_up)
	hide()

func _on_close_pressed() -> void:
	hide()

func _on_time_debug_pressed() -> void:
	_on_submenu_toggle(ui_time_control)

func _on_save_load_pressed() -> void:
	_on_submenu_toggle(ui_save_load)

func _on_submenu_close()-> void:
	show()

func _on_pop_up(topLabel, messageLabel)->void:
	get_parent().togle_pop_up_message(topLabel,messageLabel)
	
func _on_submenu_toggle(submenu:Control)->void:
	submenu.visible = !submenu.visible
	if submenu.visible:
		main_container.hide()
		submenu.show()
	else:
		submenu.hide()
		main_container.show()

func toggle_menu():
	var local_player = GlobalData.get_local_player()
	if not local_player:
		return
	if visible:
		hide()
	else:
		show()
