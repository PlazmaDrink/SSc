extends Node3D

##The purpose of this script is to hold the information crutial to be passed between the scenes

@onready var players_container: Node3D = $Players_Container
@onready var my_component_container: component_container = $ComponentContainer

@export var player_scene: PackedScene

var nickname:String = ""
var skin:String = ""
var adress:String = ""

func _ready() -> void:
	SceneManager.current_scene.host_pressed.connect(_on_host_pressed)
	SceneManager.current_scene.join_pressed.connect(_on_join_pressed)
	
	if not multiplayer.is_server():
		return
	Network.player_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_remove_player)

func _on_host_pressed(inNickname:String, inSkin:String)-> void:
	nickname = inNickname
	skin = inSkin
	Network.start_host(nickname, skin)

func _on_join_pressed(inNickname:String, inSkin:String, inAdress:String)-> void:
	nickname = inNickname
	skin = inSkin
	adress = inAdress
	Network.join_game(nickname, skin, adress)

func _on_player_connected(id: int, player_info : Dictionary):
	if DisplayServer.get_name() == "headless" and id == 1:
		return

	if players_container.has_node(str(id)):
		return

	var player = player_scene.instantiate()
	player.name = str(id)
	player.local_client_id = id
	player.position = get_spawn_point()
	players_container.add_child(player, true)

	var nick = Network.players[id]["nick"]
	player.nickname.text = nick

	var skin_enum = player_info["skin"]
	player.set_player_skin(skin_enum)

func get_spawn_point() -> Vector3:
	var spawn_point = Vector2.from_angle(randf() * 2 * PI) * 10 # spawn radius
	return Vector3(spawn_point.x, 0, spawn_point.y)

func _remove_player(id):
	if not multiplayer.is_server() or not players_container.has_node(str(id)):
		return
	var player_node = players_container.get_node(str(id))
	if player_node:
		player_node.queue_free()

func get_local_player()->Player_Character:
	var my_id = str(multiplayer.get_unique_id())
	if players_container.has_node(my_id):
		return players_container.get_node(my_id) as Player_Character
	return null
