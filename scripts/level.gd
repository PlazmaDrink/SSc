extends Node3D

#@onready var players_container: Node3D = $PlayersContainer
#@onready var main_menu: MainMenuUI = $MainMenuUI
@onready var ui_manager: UI_Manager = $UI_Manager
#@export var player_scene: PackedScene

func _ready():
	if DisplayServer.get_name() == "headless":
		print("Dedicated server starting...")
		if multiplayer.is_server():
			Network.start_host("", "")

	#main_menu.show_menu()

	#main_menu.host_pressed.connect(_on_host_pressed)
	#main_menu.join_pressed.connect(_on_join_pressed)
	#main_menu.quit_pressed.connect(_on_quit_pressed)

	if not multiplayer.is_server():
		_on_join_pressed(GlobalData.nickname, GlobalData.skin, GlobalData.adress)
		return

	#Network.connect("player_connected", Callable(self, "_on_player_connected"))
	#multiplayer.peer_disconnected.connect(_remove_player)

func _on_player_connected(peer_id, player_info):
	_add_player(peer_id, player_info)

func _on_host_pressed(nickname: String, skin: String):
	#main_menu.hide_menu()
	ui_manager.show()
	Network.start_host(nickname, skin)

func _on_join_pressed(nickname: String, skin: String, adress: String):
	#main_menu.hide_menu()
	ui_manager.show()
	Network.join_game(nickname, skin, adress)

func _add_player(id: int, player_info : Dictionary):
	if DisplayServer.get_name() == "headless" and id == 1:
		return

	if GlobalData.players_container.has_node(str(id)):
		return

	#var player = player_scene.instantiate()
	#player.name = str(id)
	#player.position = get_spawn_point()
	#GlobalData.players_container.add_child(player, true)

	#var nick = Network.players[id]["nick"]
	#player.nickname.text = nick

	#var skin_enum = player_info["skin"]
	#player.set_player_skin(skin_enum)

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
