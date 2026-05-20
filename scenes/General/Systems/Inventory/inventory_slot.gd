class_name InventorySlot
extends RefCounted

var item_id: String = ""
var quantity: int = 0
var inventory_owner_name: String
var slot_index: int
var inventory_ref: Inventory

func set_inventory_owner_name(inName:String)->void:
	inventory_owner_name = inName
	
func is_empty() -> bool:
	return item_id.is_empty() or quantity <= 0

func can_add_item(inItem: Item, amount: int = 1) -> bool:
	if is_empty():
		return true
	if item_id == inItem.id and inItem.stackable:
		return quantity + amount <= inItem.max_stack
	return false

func add_item(item: Item, amount: int = 1) -> int:
	if is_empty():
		item_id = item.id
		quantity = min(amount, item.max_stack)
		return amount - quantity
	elif item_id == item.id and item.stackable:
		var space_available = item.max_stack - quantity
		var amount_to_add = min(amount, space_available)
		quantity += amount_to_add
		return amount - amount_to_add
	return amount

func remove_item(amount: int = 1) -> int:
	var removed = min(amount, quantity)
	quantity -= removed
	if quantity <= 0:
		clear()
	return removed

func clear() -> void:
	item_id = ""
	quantity = 0

func to_dict() -> Dictionary:
	return {"item_id": item_id, "quantity": quantity, "slot_index": slot_index}

func from_dict(data: Dictionary) -> void:
	item_id = data.get("item_id", "")
	quantity = data.get("quantity", 0)
	slot_index = data.get("slot_index", 0)
