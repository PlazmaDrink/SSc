extends CustomControl
class_name MainMenuUI

signal quit_pressed

@onready var skin_input: LineEdit = $MainContainer/MainMenu/Option2/SkinInput
@onready var nick_input: LineEdit = $MainContainer/MainMenu/Option1/NickInput
@onready var address_input: LineEdit = $MainContainer/MainMenu/Option3/AddressInput
@onready var UI_manager_ref: UI_Manager = $"../.."
@onready var main_menu: Control = $".."

func initiane_UI_element() -> void:
	visible = true
func _on_host_pressed():
	var nickname = nick_input.text.strip_edges()
	var skin = skin_input.text.strip_edges().to_lower()
	Network.start_host(nickname, skin)

func _on_join_pressed():
	var nickname = nick_input.text.strip_edges()
	var skin = skin_input.text.strip_edges().to_lower()
	var address = address_input.text.strip_edges()
	Network.join_game(nickname, skin, address)

func _on_quit_pressed():
	quit_pressed.emit()

func show_menu():
	show()

func hide_menu():
	hide()

func is_menu_visible() -> bool:
	return visible

func get_nickname() -> String:
	return nick_input.text.strip_edges()

func get_skin() -> String:
	return skin_input.text.strip_edges().to_lower()

func get_address() -> String:
	return address_input.text.strip_edges()
	
func _on_visibility_changed() -> void:
	reparentOnVisibilityChange()
