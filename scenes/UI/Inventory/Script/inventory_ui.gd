extends Control
class_name InventoryUI

const INVENTORY_UI_SCENE = preload("uid://bclq8vh1x2goy")

@onready var grid_container: GridContainer = $Panel/MarginContainer/VBoxContainer/GridContainer
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleBar/Title
@onready var close_button: Button = $Panel/MarginContainer/VBoxContainer/TitleBar/CloseButton
@onready var tooltip: Control = $ItemTooltip
@onready var tooltip_label: RichTextLabel = $ItemTooltip/Panel/MarginContainer/TooltipText

var UI_manager_ref: UI_Manager

var current_player: Player_Character
var my_inventory: Inventory

var slot_ui_scene: PackedScene
var slot_uis: Array[InventorySlotUI] = []
var inventory_visible = false

signal inventory_closed

func initiane_UI_element(inMy_inventory:Inventory, inCurrent_Player: Player_Character = null)->void:
	slot_ui_scene = preload("uid://bglwdpf2mf7g0")
	grid_container.columns = 4
	close_button.pressed.connect(_on_close_pressed)
	tooltip.visible = false
	UI_manager_ref = get_parent() as UI_Manager
	if inCurrent_Player:
		current_player = inCurrent_Player
	if inMy_inventory:
		my_inventory = inMy_inventory
		my_inventory.Request_UI_Update.connect(update_inventory_display_signal)
	_create_slot_uis()
	
func _create_slot_uis():
	for child in grid_container.get_children():
		child.queue_free()
	slot_uis.clear()

	for i in range(my_inventory.inventory_size):
		var slot_ui = slot_ui_scene.instantiate() as InventorySlotUI
		slot_ui.custom_minimum_size = Vector2(64, 64)
		slot_ui.parent_inventory_UI = self

		slot_ui.slot_clicked.connect(_on_slot_clicked)
		slot_ui.item_hovered.connect(_on_item_hovered)
		slot_ui.item_unhovered.connect(_on_item_unhovered)

		slot_ui.set_slot_data(my_inventory.get_slot(i))

		grid_container.add_child(slot_ui)
		slot_uis.append(slot_ui)

func _on_slot_clicked(slot_index: int, button: int):
	print("Slot ", slot_index, " clicked with button ", button)

	match button:
		MOUSE_BUTTON_LEFT:
			pass
		MOUSE_BUTTON_RIGHT:
			_handle_right_click(slot_index)

func _handle_right_click(slot_index: int):
	if current_player:
		var slot = my_inventory.get_slot(slot_index)
		if slot and not slot.is_empty():
			var item = ItemDatabase.get_item(slot.item_id)
			if item:
				print("Right clicked on: ", item.name)
				# TODO: Show context menu or perform quick action

func _on_item_hovered(_slot_index: int, item: Item):
	_show_tooltip(item)

func _on_item_unhovered():
	_hide_tooltip()

func _show_tooltip(item: Item):
	if not item:
		return

	var tooltip_content = "[b][color=#FFD700]" + item.name + "[/color][/b]\n"
	tooltip_content += "[color=#CCCCCC]" + item.description + "[/color]\n\n"
	tooltip_content += "[color=#87CEEB]Type:[/color] " + _get_item_type_string(item.item_type) + "\n"
	tooltip_content += "[color=#FF69B4]Rarity:[/color] " + _get_rarity_string(item.rarity) + "\n"
	tooltip_content += "[color=#FFD700]Value:[/color] " + str(item.value) + " gold"

	if item.stackable:
		tooltip_content += "\n[color=#98FB98]Max Stack:[/color] " + str(item.max_stack)

	tooltip_label.text = tooltip_content
	tooltip.visible = true

	_position_tooltip_smartly()

func _hide_tooltip():
	tooltip.visible = false

func _position_tooltip_smartly():
	var mouse_pos = get_global_mouse_position()
	var tooltip_size = tooltip.size

	var viewport_size = get_viewport().get_visible_rect().size
	var tooltip_pos = mouse_pos + Vector2(10, 10)

	if tooltip_pos.x + tooltip_size.x > viewport_size.x:
		tooltip_pos.x = mouse_pos.x - tooltip_size.x - 10

	if tooltip_pos.y + tooltip_size.y > viewport_size.y:
		tooltip_pos.y = mouse_pos.y - tooltip_size.y - 10

	if tooltip_pos.x < 0:
		tooltip_pos.x = 10

	if tooltip_pos.y < 0:
		tooltip_pos.y = 10

	tooltip.global_position = tooltip_pos

func _get_item_type_string(type: Item.ItemType) -> String:
	match type:
		Item.ItemType.WEAPON: return "Weapon"
		Item.ItemType.ARMOR: return "Armor"
		Item.ItemType.CONSUMABLE: return "Consumable"
		Item.ItemType.TOOL: return "Tool"
		Item.ItemType.MISC: return "Miscellaneous"
		_: return "Unknown"

func _get_rarity_string(rarity: Item.ItemRarity) -> String:
	match rarity:
		Item.ItemRarity.COMMON: return "Common"
		Item.ItemRarity.UNCOMMON: return "Uncommon"
		Item.ItemRarity.RARE: return "Rare"
		Item.ItemRarity.EPIC: return "Epic"
		Item.ItemRarity.LEGENDARY: return "Legendary"
		_: return "Unknown"

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE and visible:
			_on_close_pressed()

func _on_close_pressed():
	if current_player == null:
		queue_free()
		return
	inventory_closed.emit()
	visible = false

func handle_item_drop(source_inv_id: String, source_slot: int, target_slot: int, item_id: String, qty: int):
	# If we are a client, send an RPC to request this move from the server
	if not multiplayer.is_server():
		my_inventory.inventory_component_ref.request_move_item.rpc_id(
			1,
			source_inv_id,
			source_slot,
			item_id,
			target_slot,
			qty)
		return
	else:
		my_inventory.inventory_component_ref.move_item(source_inv_id, source_slot, item_id, target_slot, qty)

func open_inventory():
	update_inventory_display()
	visible = true

func close_inventory():
	visible = false
	if is_in_group("Temp"):
		get_parent().remove_child(self)
		queue_free()

func toggle_inventory():
	if not current_player:
		return
	inventory_visible = !inventory_visible
	if inventory_visible:
		open_inventory()
	else:
		close_inventory()

func update_inventory_display():
	for i in range(slot_uis.size()):
		if i < my_inventory.inventory_size:
			slot_uis[i].set_slot_data(my_inventory.get_slot(i))

func update_inventory_display_signal():
	for i in range(slot_uis.size()):
		if i < my_inventory.inventory_size:
			slot_uis[i].set_slot_data(my_inventory.get_slot(i))

func set_title(newTitle:String)->void:
	title_label.text = newTitle

func is_inventory_visible() -> bool:
	return inventory_visible

func _on_inventory_closed():
	inventory_visible = false

func debug_add_item():
	if current_player:
		var test_items = ["iron_sword", "health_potion", "leather_armor", "magic_gem", "iron_pickaxe"]
		var random_item = test_items[randi() % test_items.size()]
		print("Debug: Requesting to add ", random_item, " to player ", current_player.name, " (authority: ", current_player.get_multiplayer_authority(), ")")
		current_player.my_component_container.get_component(GameEnums.Components.InventoryComponent).request_add_item.rpc_id(1, random_item, 1)
		update_inventory_display()
	else:
		print("Debug: No local player found!")

func debug_print_inventory():
	var local_player = GlobalData.get_local_player()
	var players_inventory = local_player.my_component_container.get_component(GameEnums.Components.InventoryComponent).get_inventory()
	if local_player and players_inventory:
		print("=== Inventory Debug ===")
		for i in range(players_inventory.slots.size()):
			var slot = players_inventory.get_slot(i)
			if slot and not slot.is_empty():
				print("Slot ", i, ": ", slot.item_id, " x", slot.quantity)
		print("=====================")
	else:
		print("No inventory found for local player")

func _on_visibility_changed() -> void:
	if visible:
		self.reparent(UI_manager_ref.currently_on_display)
		my_inventory.isOpen = true
	else:
		self.reparent(UI_manager_ref)
		my_inventory.isOpen = false
