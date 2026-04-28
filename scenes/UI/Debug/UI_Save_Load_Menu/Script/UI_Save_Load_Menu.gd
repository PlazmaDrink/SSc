extends Control
class_name UI_Save_Load_Menu

@onready var save_name_input: LineEdit = $ColorRect/MainContainer/TimeMenu/Option1/NewSave_HContainer/SaveNameInput
@onready var load_game_list_container: VBoxContainer = $ColorRect/LoadGameListContainer
@onready var main_container: VBoxContainer = $ColorRect/MainContainer
@onready var scroll_v_box_container: VBoxContainer = $ColorRect/LoadGameListContainer/LoadGameList/ScrollContainer/VBoxContainer

var loadButtonList: Array[Button] = []
var tempLoadFileName: String = ""
signal on_Close
signal on_Pop_up_request(windowLabel, messageLabel)

func _on_close_pressed() -> void:
	hide_menu()
	on_Close.emit()

func show_menu():
	SaveLoad.update_name_to_path_dict()
	_update_loadlist()
	show()

func hide_menu():
	hide()
	
func is_menu_visible() -> bool:
	return visible
	
func open_ui_save_load_menu(player: Player_Character = null):
	if player:
		visible = true

func _on_save_game_pressed() -> void:
	SaveLoad.save_game()
	on_Pop_up_request.emit("Warning", "Game saved")

func _on_new_save_pressed() -> void:
	SaveLoad.save_game(save_name_input.text)

func _on_load_game_pressed() -> void:
	main_container.hide()
	load_game_list_container.show()
	

## Updates buttons in Load Game List according to current state of SaveGame directory 
func _update_loadlist()->void:
	#Delete all existing buttons
	if scroll_v_box_container.get_child_count() != 0:
		for child in scroll_v_box_container.get_children():
			child.queue_free()

	#Create buttons according to files in SaveGame directory
	for item in SaveLoad.name_to_path_dict:
		var button = Button.new()
		scroll_v_box_container.add_child(button)
		loadButtonList.append(button)
		button.text = item
		button.pressed.connect(test_func.bind(button))
	pass
	
func test_func(button:Button)->void:
	tempLoadFileName = button.text
#Buttons
func _on_back_pressed() -> void:
	load_game_list_container.hide()
	main_container.show()

func _on_load_pressed() -> void:
	load_game_list_container.hide()
	main_container.show()
	SaveLoad.load_game(tempLoadFileName)
