class_name GameState_Local
extends Node

const UI_MANAGER_SCENE = preload("uid://cxwfmkvydqapy")


var player:Player_Character
var UI_manager:UI_Manager
var isStateReady:bool = false
var isItemsLoaded:bool = false
func _ready() -> void:
	Network.player_connected.connect(on_player_connected)
	ItemDatabase.ItemsLoaded.connect(on_items_loaded)
	ItemDatabase.start()

func on_player_connected(peer_id:int, player_info:Dictionary)->void:
	if !player:
		set_multiplayer_authority(peer_id)
		player = GlobalData.get_local_player()
		player.game_state = self
	if player.is_multiplayer_authority() and !UI_manager:
		initiate_UI_manager(peer_id, player_info)
		isStateReady = true

func initiate_UI_manager(peer_id:int, player_info:Dictionary)->void:
	if isItemsLoaded:
		UI_manager = UI_MANAGER_SCENE.instantiate() as UI_Manager
		self.add_child(UI_manager)
		UI_manager.initiate_manager(peer_id, player_info)
	else:
		print_debug("Items in ItemDatabase are not loaded yet!!!")

func getUI_manager()->UI_Manager:
	return UI_manager

func on_items_loaded():
	isItemsLoaded = true
