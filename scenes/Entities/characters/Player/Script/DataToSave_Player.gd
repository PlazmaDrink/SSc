class_name data_to_save_player
extends data_to_save_custom

var peer_id
var player_info: Dictionary

func _init() -> void:
	Network.player_connected.connect(_on_player_connected)
func save_properties(root:Node, custom:Node = null, inIsGlobal = false)->void:
	super.save_properties(root, custom, inIsGlobal)

func load_properties(root:Node = null, _custom:Node = null)->void:
	super.load_properties(root)

func _on_player_connected(inPeer_id, inPlayer_info):
	peer_id = inPeer_id
	player_info = inPlayer_info
