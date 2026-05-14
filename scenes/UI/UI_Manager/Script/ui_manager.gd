class_name UI_Manager
extends Control

@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var multiplayer_chat_ui: MultiplayerChatUI = $MultiplayerChatUI
@onready var ui_debug: UI_Debug = $UI_Debug
@onready var survival_bars: Control = $SurvivalBars
@onready var currently_on_display: HBoxContainer = $CurrentlyOnDisplay

const POP_UP_MESSAGE = preload("uid://cmi5io0cl7ms1")
const INVENTORY_UI_SCENE = preload("uid://bclq8vh1x2goy")

var chat_visible = false
var UI_debug_menu_visible = false

func _ready() -> void:
	show()
	multiplayer_chat_ui.hide()
	multiplayer_chat_ui.set_process_input(true)
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
		if inventory_ui.current_player == null:
			inventory_ui.set_current_player(GlobalData.get_local_player())
		inventory_ui.toggle_inventory()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_F1:
		inventory_ui.debug_add_item()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_F2:
		inventory_ui.debug_print_inventory()
	elif event.is_action_pressed("DebugMenu"):
		toggle_UI_debug_menu()
	check_if_mouse_on_screen_required()

##Toggle mouse visibility and input focus between game and UI
func check_if_mouse_on_screen_required()->void:
	if inventory_ui.visible or ui_debug.visible or multiplayer_chat_ui.visible or currently_on_display.get_child_count() != 0:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_filter = Control.MOUSE_FILTER_IGNORE

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
	add_to_currently_on_display(pop_up_instance)
	pop_up_instance.update_pop_up_message(topLabel, messageLabel)
# ---------- Pop Up Message ----------

func add_to_currently_on_display(childToAdd: Node)->void:
	if childToAdd.get_parent() == null:
		currently_on_display.add_child(childToAdd)
		childToAdd.reparent(currently_on_display)

func _on_inventory_ui_visibility_changed() -> void:
	if inventory_ui.visible:
		inventory_ui.reparent(currently_on_display)
	else:
		inventory_ui.reparent(self)
		if currently_on_display.get_child_count() == 0:
			currently_on_display.visible = false

func _on_currently_on_display_child_entered_tree(_node: Node) -> void:
		currently_on_display.visible = true	
