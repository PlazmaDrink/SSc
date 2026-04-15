class_name UI_Manager
extends Control

@onready var inventory_slot_ui: InventorySlotUI = $InventorySlotUI
@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var multiplayer_chat_ui: MultiplayerChatUI = $MultiplayerChatUI
@onready var ui_debug: UI_Debug = $UI_Debug
@onready var container_for_temp: Node = $ContainerForTemp
@onready var survival_bars: Control = $SurvivalBars
const POP_UP_MESSAGE = preload("uid://cmi5io0cl7ms1")


var chat_visible = false
var inventory_visible = false
var UI_debug_menu_visible = false

func _ready() -> void:
	show()
	# This line will hide mouse
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	multiplayer_chat_ui.hide()
	multiplayer_chat_ui.set_process_input(true)
	
	if inventory_ui:
		inventory_ui.inventory_closed.connect(_on_inventory_closed)

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
		toggle_inventory()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_F1:
		_debug_add_item()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_F2:
		_debug_print_inventory()
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
	
# ---------- INVENTORY SYSTEM ----------
func toggle_inventory():
	var local_player = get_parent().get_local_player()
	if not local_player:
		return

	inventory_visible = !inventory_visible
	if inventory_visible:
		inventory_ui.open_inventory(local_player)
	else:
		inventory_ui.close_inventory()

func is_inventory_visible() -> bool:
	return inventory_visible

func _on_inventory_closed():
	inventory_visible = false
	
func update_local_inventory_display():
	if inventory_ui:
		# Always refresh if the UI exists, regardless of visibility
		inventory_ui.refresh_display()
		print("Debug: Inventory display updated from server sync")

# Debug functions for testing inventory system
func _debug_add_item():
	var local_player = get_parent().get_local_player()
	if local_player:
		var test_items = ["iron_sword", "health_potion", "leather_armor", "magic_gem", "iron_pickaxe"]
		var random_item = test_items[randi() % test_items.size()]
		print("Debug: Requesting to add ", random_item, " to player ", local_player.name, " (authority: ", local_player.get_multiplayer_authority(), ")")
		local_player.request_add_item.rpc_id(1, random_item, 1)
	else:
		print("Debug: No local player found!")

func _debug_print_inventory():
	var local_player = get_parent().get_local_player()
	if local_player and local_player.get_inventory():
		var inventory = local_player.get_inventory()
		print("=== Inventory Debug ===")
		for i in range(inventory.slots.size()):
			var slot = inventory.get_slot(i)
			if slot and not slot.is_empty():
				print("Slot ", i, ": ", slot.item_id, " x", slot.quantity)
		print("=====================")
	else:
		print("No inventory found for local player")

# ---------- UI_Time_Menu ----------
func toggle_UI_debug_menu():
	if ui_debug.is_menu_visible():
		ui_debug.hide_menu()
		return
	var local_player = get_parent().get_local_player()
	if not local_player:
		return
	UI_debug_menu_visible = !UI_debug_menu_visible
	if UI_debug_menu_visible:
		ui_debug.open_UI_debug_menu(local_player)
	else:
		ui_debug.hide_menu()
#func is_UI_Debug_Menu_visible() -> bool:
	#return UI_debug_menu_visible
# ---------- UI_Time_Menu ----------

# ---------- Pop Up Message ----------
func togle_pop_up_message(topLabel:String, messageLabel:String):
	var local_player = get_parent().get_local_player()
	if not local_player:
		return
	var pop_up_instance
	pop_up_instance = POP_UP_MESSAGE.instantiate()
	container_for_temp.add_child(pop_up_instance)
	pop_up_instance.update_pop_up_message(topLabel, messageLabel)
# ---------- Pop Up Message ----------
