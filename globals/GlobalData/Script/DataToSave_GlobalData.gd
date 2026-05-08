class_name data_to_save_custom_global_data

extends data_to_save_custom
const PRELOAD_CUSTOM = preload("uid://c2di55v3108hj")

@export var peer_id: Array = []
@export var player_info: Array[Dictionary] 

func _init() -> void:
	Network.player_connected.connect(_on_player_connected)

func save_properties(root:Node, custom:Node = null, inIsGlobal = false)->void:
	super.save_properties(root, custom, inIsGlobal)

func load_properties(_root:Node = null, _custom:Node = null)->void:
	pass

func _on_player_connected(inPeer_id, inPlayer_info):
	if player_info.find(inPlayer_info) == -1:
		player_info.append(inPlayer_info)
	if peer_id.find(inPeer_id) == -1:
		peer_id.append(inPeer_id)

func get_preload()->Resource:
	return PRELOAD_CUSTOM
