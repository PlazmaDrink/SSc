extends Control
class_name UI_Save_Load_Menu

signal on_Close
# Called when the node enters the scene tree for the first time.

func _on_close_pressed() -> void:
	hide_menu()
	on_Close.emit()

func show_menu():
	show()

func hide_menu():
	hide()
	
func is_menu_visible() -> bool:
	return visible
	
func open_ui_save_load_menu(player: Character = null):
	if player:
		visible = true


func _on_save_game_pressed() -> void:
	SaveLoad.save_game()

func _on_load_game_pressed() -> void:
	SaveLoad.load_game()
