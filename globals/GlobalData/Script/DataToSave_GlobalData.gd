class_name DataToSave_GlobalData

extends DataToSave
const PRELOAD_CUSTOM = preload("uid://c2di55v3108hj")

@export var peer_id: Array = []
@export var player_info: Array[Dictionary] 

func _init() -> void:
	Network.player_connected.connect(_on_player_connected)

func save_properties()->void:
	super.save_properties()

func load_properties()->void:
	super.load_properties()

func _on_player_connected(inPeer_id, inPlayer_info):
	if player_info.find(inPlayer_info) == -1:
		player_info.append(inPlayer_info)
	if peer_id.find(inPeer_id) == -1:
		peer_id.append(inPeer_id)

func get_preload()->Resource:
	return PRELOAD_CUSTOM
