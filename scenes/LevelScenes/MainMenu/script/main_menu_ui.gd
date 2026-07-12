extends Control
class_name MainMenuUI

signal quit_pressed

@onready var skin_input: LineEdit = $MainContainer/MainMenu/Option2/SkinInput
@onready var nick_input: LineEdit = $MainContainer/MainMenu/Option1/NickInput
@onready var address_input: LineEdit = $MainContainer/MainMenu/Option3/AddressInput
@onready var level_selection_menu: Control = $LevelSelectionMenu

func _ready() -> void:
	visible = true
	level_selection_menu.level_loaded.connect(on_level_loaded)

func _on_host_pressed():
	var nickname = nick_input.text.strip_edges()
	var skin = skin_input.text.strip_edges().to_lower()
	level_selection_menu.show()
	await SceneManager.scene_loaded
	Network.start_host(nickname, skin)

func _on_join_pressed():
	var nickname = nick_input.text.strip_edges()
	var skin = skin_input.text.strip_edges().to_lower()
	var address = address_input.text.strip_edges()
	level_selection_menu.show()
	await SceneManager.scene_loaded
	Network.join_game(nickname, skin, address)

func on_level_loaded():
	queue_free()

func _on_quit_pressed():
	quit_pressed.emit()

func get_nickname() -> String:
	return nick_input.text.strip_edges()

func get_skin() -> String:
	return skin_input.text.strip_edges().to_lower()

func get_address() -> String:
	return address_input.text.strip_edges()
