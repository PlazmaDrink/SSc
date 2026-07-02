extends Node

const SERVER_ADDRESS: String = "127.0.0.1"
const SERVER_PORT: int = 8080
const MAX_PLAYERS : int = 10

var players = {}
var player_info = {
	"nick" : "host",
	"skin" : Player_Character.SkinColor.BLUE,
}

signal player_connected(peer_id, player_info)
signal server_disconnected

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit(0)

func _ready() -> void:
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)

func start_host(nickname: String, skin_color_str: String):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(SERVER_PORT, MAX_PLAYERS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

	if !nickname or nickname.strip_edges() == "":
		nickname = "Host_" + str(multiplayer.get_unique_id())

	player_info["nick"] = nickname
	player_info["skin"] = skin_str_to_e(skin_color_str)
	player_info["peer"] = peer
	
	if DisplayServer.get_name() == "headless":
		return

	players[1] = player_info
	player_connected.emit(1, player_info)
	SceneManager.change_scene(SceneManager.game_scenes_dict.get("LevelSelection"))


func join_game(nickname: String, skin_color_str: String, address: String = SERVER_ADDRESS):
	await get_tree().process_frame
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, SERVER_PORT)
	if error:
		return error

	multiplayer.multiplayer_peer = peer

	if !nickname or nickname.strip_edges() == "":
		nickname = "Player_" + str(multiplayer.get_unique_id())

	var skin_enum = skin_str_to_e(skin_color_str)

	player_info["nick"] = nickname
	player_info["skin"] = skin_enum
	player_info["peer"] = peer

func _on_connected_ok():
	SceneManager.change_scene(SceneManager.game_scenes_dict.get("MainLevel"))
	await SceneManager.scene_loaded
	_request_to_join_server.rpc_id(1, player_info)
	

@rpc("any_peer", "reliable")
func _request_to_join_server(new_player_info):
	# If a client somehow receives this, ignore it. Only the Server processes this.
	if not multiplayer.is_server():
		return
		
	var new_player_id = multiplayer.get_remote_sender_id()
	
	# The Server adds the new player to its master list
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)
	
	# The Server tells ALL existing clients to add the new player
	_register_player_on_clients.rpc(new_player_id, new_player_info)
	
	# The Server must also tell the NEW player about everyone who is ALREADY here
	for existing_id in players:
		if existing_id != new_player_id:
			_register_player_on_clients.rpc_id(new_player_id, existing_id, players[existing_id])

@rpc("authority", "reliable")
func _register_player_on_clients(new_player_id, new_player_info):
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)

func _on_player_disconnected(id):
	players.erase(id)

func _on_connection_failed():
	multiplayer.multiplayer_peer = null
	SceneManager.change_scene(SceneManager.game_scenes_dict.get("MainMenu"))

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()

func skin_str_to_e(s):
	match s.to_lower():
		"blue": return Player_Character.SkinColor.BLUE
		"yellow": return Player_Character.SkinColor.YELLOW
		"green": return Player_Character.SkinColor.GREEN
		"red": return Player_Character.SkinColor.RED
		_: return Player_Character.SkinColor.BLUE
