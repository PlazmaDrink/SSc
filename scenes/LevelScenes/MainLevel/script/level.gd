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

func _on_player_connected(peer_id, player_info):
	_add_player(peer_id, player_info)

func _on_host_pressed(nickname: String, skin: String):
	#main_menu.hide_menu()
	ui_manager.show()
	Network.start_host(nickname, skin)

func _on_join_pressed(nickname: String, skin: String, adress: String):
	ui_manager.show()
	Network.join_game(nickname, skin, adress)

func _add_player(id: int, player_info : Dictionary):
	if DisplayServer.get_name() == "headless" and id == 1:
		return

	if GlobalData.players_container.has_node(str(id)):
		return

func get_spawn_point() -> Vector3:
	var spawn_point = Vector2.from_angle(randf() * 2 * PI) * 10 # spawn radius
	return Vector3(spawn_point.x, 0, spawn_point.y)

func _remove_player(id):
	if not multiplayer.is_server() or not GlobalData.players_container.has_node(str(id)):
		return
	var player_node = GlobalData.players_container.get_node(str(id))
	if player_node:
		player_node.queue_free()

func _on_quit_pressed() -> void:
	get_tree().quit()

# Additional helper for testing
func _notification(what):
	if what == NOTIFICATION_READY:
		print("Inventory System Controls:")
		print("  B - Toggle inventory")
		print("  F1 - Add random test item (debug)")
		print("  F2 - Print inventory contents (debug)")

func get_local_player() -> Character:
	var local_player_id = multiplayer.get_unique_id()
	if GlobalData.players_container.has_node(str(local_player_id)):
		return GlobalData.players_container.get_node(str(local_player_id)) as Character
	return null
