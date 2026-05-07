extends Node3D

@onready var ui_manager: UI_Manager = $UI_Manager

func _ready():
	if is_multiplayer_authority():
		GlobalData.UI_manager = ui_manager

func _on_quit_pressed() -> void:
	get_tree().quit()
