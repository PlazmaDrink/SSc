extends SlotUI
class_name StoreSlotUI

var store_item: StoreItem

func set_store_slot_data(inStore_item: StoreItem):
	store_item = inStore_item
	call_deferred("setSlotIcon")

func setSlotIcon()->void:
	if store_item:
		item_icon.texture = store_item.icon
	else:
		print_debug("No store_item set")
