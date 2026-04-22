class_name DataToSave_Player
extends DataToSave_Custom

var peer_id
var player_info: Dictionary

func _init() -> void:
	Network.player_connected.connect(_on_player_connected)
func save_properties(root:Node, custom:Node = null, isGlobal = false)->void:
	super.save_properties(root, custom, isGlobal)

func load_properties(root:Node = null, custom:Node = null)->void:
	super.load_properties(root)

func _on_player_connected(inPeer_id, inPlayer_info):
	peer_id = inPeer_id
	player_info = inPlayer_info
