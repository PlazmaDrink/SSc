extends SlotUI
class_name InventorySlotUI

@onready var quantity_label: Label = $QuantityLabel

signal item_hovered(slot_index: int, item: Item)
signal item_unhovered
var inventory_slot: InventorySlot
var parent_inventory_UI: Control

const RARITY_COLORS = {
	Item.ItemRarity.COMMON: Color.WHITE,
	Item.ItemRarity.UNCOMMON: Color.GREEN,
	Item.ItemRarity.RARE: Color.BLUE,
	Item.ItemRarity.EPIC: Color.PURPLE,
	Item.ItemRarity.LEGENDARY: Color.ORANGE
}

func set_inventory_slot_data(slot_data: InventorySlot):
	inventory_slot = slot_data
	if inventory_slot:
		slot_index = slot_data.slot_index
	call_deferred("update_display")

func update_display():
	if not inventory_slot or inventory_slot.is_empty():
		_show_empty_slot()
	else:
		_show_item_slot()

func _on_mouse_exited():
	item_unhovered.emit()
	background.modulate = Color.WHITE

func _on_mouse_entered():
	if inventory_slot and not inventory_slot.is_empty():
		var item = ItemDatabase.get_item(inventory_slot.item_id)
		if item:
			item_hovered.emit(slot_index, item)
	background.modulate = Color(1.2, 1.2, 1.2)

func _show_empty_slot():
	if item_icon:
		item_icon.texture = null
	if quantity_label:
		quantity_label.visible = false
	if rarity_border:
		rarity_border.visible = false
	if background:
		background.modulate = Color.WHITE

func _show_item_slot():
	var item = ItemDatabase.get_item(inventory_slot.item_id)
	if not item:
		_show_empty_slot()
		return

	item_icon.texture = item.icon

	if item.stackable and inventory_slot.quantity > 1:
		quantity_label.text = str(inventory_slot.quantity)
		quantity_label.visible = true
	else:
		quantity_label.visible = false

	if RARITY_COLORS.has(item.rarity):
		rarity_border.modulate = RARITY_COLORS[item.rarity]
		rarity_border.visible = true
	else:
		rarity_border.visible = false

func _can_drop_data(_position: Vector2, data) -> bool:
	return data is InventorySlot

func _drop_data(_position: Vector2, data):
	if not parent_inventory_UI or not parent_inventory_UI.has_method("handle_item_drop"):
		return
	parent_inventory_UI.handle_item_drop(
		data.inventory_id, 
		data.slot_index, 
		inventory_slot.slot_index, 
		data.item_id, 
		data.quantity
	)

func _get_drag_data(_position: Vector2):
	if not inventory_slot or inventory_slot.is_empty():
		return null

	var item = ItemDatabase.get_item(inventory_slot.item_id)
	if not item:
		return null

	var preview = Control.new()
	var preview_icon = TextureRect.new()
	preview_icon.texture = item.icon
	preview_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_icon.size = Vector2(32, 32)
	preview.add_child(preview_icon)

	preview.modulate = Color(1, 1, 1, 0.8)
	set_drag_preview(preview)

	item_icon.modulate = Color(0.5, 0.5, 0.5)

	return inventory_slot

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		item_icon.modulate = Color.WHITE
