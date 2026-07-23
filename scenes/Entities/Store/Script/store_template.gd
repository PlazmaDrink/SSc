extends Node3D
class_name StoreTemplate

@onready var store_purchased_items: Node3D = $StorePurchasedItems

func add_new_store_item(store_item:Node)->void:
	store_purchased_items.add_child(store_item)
