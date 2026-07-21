class_name UI_Manager
extends Control

@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var multiplayer_chat_ui: MultiplayerChatUI = $MultiplayerChatUI
@onready var ui_debug: UI_Debug = $UI_Debug
@onready var survival_bars: CustomControl = $SurvivalBars
@onready var temp: Control = $Temp
@onready var store_ui: Store_UI = $StoreUi

const POP_UP_MESSAGE = preload("uid://cmi5io0cl7ms1")

var CurrentlyVisible:Array[CustomControl] = []
var UI_debug_menu_visible = false

func _ready() -> void:
	show()

##Called from game_state.gd
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
			inventory_ui.toggle_inventory()
		elif event is InputEventKey and event.pressed and event.keycode == KEY_F1:
			inventory_ui.debug_add_item()
		elif event is InputEventKey and event.pressed and event.keycode == KEY_F2:
			inventory_ui.debug_print_inventory()
		elif event.is_action_pressed("DebugMenu"):
			ui_debug.toggle_menu()

func initiate_children(_peer_id, _player_info):
	var local_player = GlobalData.get_local_player()
	var inventory_to_plug_with_UI = local_player.my_component_container.get_component(GameEnums.Components.InventoryComponent).get_inventory()
	inventory_ui.initiane_vars(inventory_to_plug_with_UI, local_player)
	for child in get_children():
		if child is CustomControl:
			child.initiane_UI_element()
			register_ui_element(child)
	check_if_mouse_on_screen_required()

func register_ui_element(element:CustomControl)->void:
	if not element.visibility_changed.is_connected(UpdateCurrentlyVisible):
		element.visibility_changed.connect(UpdateCurrentlyVisible.bind(element))

func UpdateCurrentlyVisible(inUIElement: CustomControl):
	if inUIElement.visible:
		if not inUIElement in CurrentlyVisible:
			CurrentlyVisible.append(inUIElement)
	else:
		CurrentlyVisible.erase(inUIElement)
	check_if_mouse_on_screen_required()

##Toggle mouse visibility and input focus between game and UI
func check_if_mouse_on_screen_required()->void:
	if CurrentlyVisible.is_empty():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_filter = Control.MOUSE_FILTER_PASS
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		mouse_filter = Control.MOUSE_FILTER_STOP
	print("Visible UI elements count: ", CurrentlyVisible.size(), " | Array contents: ", CurrentlyVisible)

func add_to_currently_on_display(childToAdd: Node)->void:
	if childToAdd.get_parent() == null:
		temp.add_child(childToAdd)

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
		non_player_inventory.initiane_vars(inventory)
		non_player_inventory.initiane_UI_element()
		non_player_inventory.set_title(Title) 
		non_player_inventory.open_inventory()
		UpdateCurrentlyVisible(non_player_inventory)
		check_if_mouse_on_screen_required()

func _on_temp_child_entered_tree(_node: Node) -> void:
	temp.visible = true
	temp.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_temp_visibility_changed() -> void:
	check_if_mouse_on_screen_required()

func _on_temp_child_exiting_tree(_node: Node) -> void:
	if temp.get_children().size() == 1:
		CurrentlyVisible.erase(_node)
		temp.visible = false
		
