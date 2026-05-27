class_name UI_Manager
extends Control

@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var multiplayer_chat_ui: MultiplayerChatUI = $MultiplayerChatUI
@onready var ui_debug: UI_Debug = $UI_Debug
@onready var survival_bars: Control = $SurvivalBars
@onready var currently_on_display: HBoxContainer = $CurrentlyOnDisplay

const POP_UP_MESSAGE = preload("uid://cmi5io0cl7ms1")

var UI_debug_menu_visible = false

func initiate_manager(id: int, player_info : Dictionary) -> void:
	show()
	set_multiplayer_authority(id, true)
	call_deferred("initiate_children", id, player_info)
	
func _input(event):
	if is_multiplayer_authority():
		if event.is_action_pressed("toggle_chat"):
			multiplayer_chat_ui.toggle_chat()
		elif multiplayer_chat_ui.visible and multiplayer_chat_ui.message.has_focus():
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
			ui_debug.toggle_menu()
		check_if_mouse_on_screen_required()

func initiate_children(_peer_id, _player_info):
	var local_player = GlobalData.get_local_player()
	var inventory_to_plug_with_UI = local_player.my_component_container.get_component(GameEnums.Components.InventoryComponent).get_inventory()
	inventory_ui.initiane_UI_element(inventory_to_plug_with_UI, local_player)
	multiplayer_chat_ui.initiane_UI_element()

##Toggle mouse visibility and input focus between game and UI
func check_if_mouse_on_screen_required()->void:
	if currently_on_display.get_child_count() == 0:
		currently_on_display.visible = false
	for child in get_children():
		if child.visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			mouse_filter = Control.MOUSE_FILTER_STOP
			break
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		mouse_filter = Control.MOUSE_FILTER_IGNORE

func add_to_currently_on_display(childToAdd: Node)->void:
	if childToAdd.get_parent() == null:
		currently_on_display.add_child(childToAdd)
		childToAdd.reparent(currently_on_display)

func _on_currently_on_display_child_entered_tree(_node: Node) -> void:
		currently_on_display.visible = true	

# ---------- Pop Up Message ----------
func togle_pop_up_message(topLabel:String, messageLabel:String):
	var local_player = GlobalData.get_local_player()
	if not local_player:
		return
	var pop_up_instance = POP_UP_MESSAGE.instantiate()
	add_to_currently_on_display(pop_up_instance)
	pop_up_instance.update_pop_up_message(topLabel, messageLabel)
# ---------- Pop Up Message ----------

func add_non_player_inventory_to_viewport(inventory: Inventory, Title:String = "Inventory")->void:
	if inventory is not PlayerInventory:
		var non_player_inventory = inventory_ui.INVENTORY_UI_SCENE.instantiate() as InventoryUI
		add_to_currently_on_display(non_player_inventory)
		non_player_inventory.add_to_group("Temp")
		non_player_inventory.initiane_UI_element(inventory)
		non_player_inventory.set_title(Title)
		non_player_inventory.open_inventory()
