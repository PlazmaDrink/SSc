extends Control
class_name UI_Debug

@onready var ui_time_control: UI_Time_Control = $SubMenus/UI_TimeControl
@onready var ui_save_load: UI_Save_Load_Menu = $SubMenus/UI_Save_Load

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_time_control.hide_menu()
	ui_time_control.on_Close.connect(_on_submenu_close)
	ui_save_load.on_Close.connect(_on_submenu_close)
	hide_menu()

func _on_close_pressed() -> void:
	hide_menu()

func show_menu():
	show()

func hide_menu():
	hide()
	
func is_menu_visible() -> bool:
	return visible
	
func open_UI_debug_menu(player: Character = null):
	if player:
		visible = true

func _on_time_debug_pressed() -> void:
	ui_time_control.show_menu()
	hide_menu()

func _on_save_load_pressed() -> void:
	ui_save_load.show_menu()
	hide_menu()

func _on_submenu_close()-> void:
	show_menu()
