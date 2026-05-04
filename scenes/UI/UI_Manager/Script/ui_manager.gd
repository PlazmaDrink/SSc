class_name UI_Manager
extends Control

@onready var inventory_slot_ui: InventorySlotUI = $InventorySlotUI
@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var multiplayer_chat_ui: MultiplayerChatUI = $MultiplayerChatUI
@onready var ui_debug: UI_Debug = $UI_Debug
@onready var container_for_temp: Node = $ContainerForTemp
@onready var survival_bars: Control = $SurvivalBars
const POP_UP_MESSAGE = preload("uid://cmi5io0cl7ms1")
const INVENTORY_UI_SCENE = preload("uid://bclq8vh1x2goy")


var chat_visible = false
var UI_debug_menu_visible = false

func _ready() -> void:
	show()
	# This line will hide mouse
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	multiplayer_chat_ui.hide()
	multiplayer_chat_ui.set_process_input(true)
	
	if inventory_ui:
		inventory_ui.initiane_vars\
		(GlobalData.get_local_player().my_component_container.get_component(GameEnums.Components.InventoryComponent).owner_inventory, \
		GlobalData.get_local_player())
	if multiplayer_chat_ui:
		multiplayer_chat_ui.message_sent.connect(_on_chat_message_sent)


func _input(event):
	if event.is_action_pressed("toggle_chat"):
		toggle_chat()
	elif chat_visible and multiplayer_chat_ui.message.has_focus():
		if event is InputEventKey and event.keycode == KEY_ENTER and event.pressed:
			multiplayer_chat_ui._on_send_pressed()
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("inventory"):
		inventory_ui.toggle_inventory()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_F1:
		inventory_ui.debug_add_item()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_F2:
		inventory_ui.debug_print_inventory()
	elif event.is_action_pressed("DebugMenu"):
		toggle_UI_debug_menu()

# ---------- MULTIPLAYER CHAT ----------

func toggle_chat():
	multiplayer_chat_ui.toggle_chat()
	chat_visible = multiplayer_chat_ui.is_chat_visible()

func is_chat_visible() -> bool:
	return multiplayer_chat_ui.is_chat_visible()

func _on_chat_message_sent(message_text: String) -> void:
	var trimmed_message = message_text.strip_edges()
	if trimmed_message == "":
		return # do not send empty messages

	var nick = Network.players[multiplayer.get_unique_id()]["nick"]
	rpc("msg_rpc", nick, trimmed_message)
	
@rpc("any_peer", "call_local")
func msg_rpc(nick, msg):
	multiplayer_chat_ui.add_message(nick, msg)
	
# ---------- UI_Time_Menu ----------
func toggle_UI_debug_menu():
	if ui_debug.is_menu_visible():
		ui_debug.hide_menu()
		return
	var local_player = GlobalData.get_local_player()
	if not local_player:
		return
	UI_debug_menu_visible = !UI_debug_menu_visible
	if UI_debug_menu_visible:
		ui_debug.open_UI_debug_menu(local_player)
	else:
		ui_debug.hide_menu()

# ---------- Pop Up Message ----------
func togle_pop_up_message(topLabel:String, messageLabel:String):
	var local_player = GlobalData.get_local_player()
	if not local_player:
		return
	var pop_up_instance = POP_UP_MESSAGE.instantiate()
	add_child_to_temp_container(pop_up_instance)
	#container_for_temp.add_child(pop_up_instance)
	pop_up_instance.update_pop_up_message(topLabel, messageLabel)
# ---------- Pop Up Message ----------

func add_child_to_temp_container(childToAdd: Node)->void:
	container_for_temp.add_child(childToAdd)
