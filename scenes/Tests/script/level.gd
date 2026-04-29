extends Node3D

@onready var ui_manager: UI_Manager = $UI_Manager

func _ready():
	if is_multiplayer_authority():
		GlobalData.UI_manager = ui_manager

func _on_quit_pressed() -> void:
	get_tree().quit()

# Additional helper for testing
func _notification(what):
	if what == NOTIFICATION_READY:
		print("Inventory System Controls:")
		print("  B - Toggle inventory")
		print("  F1 - Add random test item (debug)")
		print("  F2 - Print inventory contents (debug)")
