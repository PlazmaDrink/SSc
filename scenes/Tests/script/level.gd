extends Node3D

@onready var ui_manager: UI_Manager = $UI_Manager

func _ready():
	if DisplayServer.get_name() == "headless":
		print("Dedicated server starting...")
		if multiplayer.is_server():
			Network.start_host("", "")

	if not multiplayer.is_server():
		_on_join_pressed(GlobalData.nickname, GlobalData.skin, GlobalData.adress)
		return
	if is_multiplayer_authority():
		GlobalData.UI_manager = ui_manager

func _on_join_pressed(nickname: String, skin: String, adress: String):
	ui_manager.show()
	Network.join_game(nickname, skin, adress)

func _on_quit_pressed() -> void:
	get_tree().quit()

# Additional helper for testing
func _notification(what):
	if what == NOTIFICATION_READY:
		print("Inventory System Controls:")
		print("  B - Toggle inventory")
		print("  F1 - Add random test item (debug)")
		print("  F2 - Print inventory contents (debug)")
