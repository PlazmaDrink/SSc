extends Node3D
class_name StoreTemplate

@onready var items_container: Node3D = $StorePurchasedItems

func add_new_store_item(store_item:Node)->void:
	items_container.add_child(store_item)
