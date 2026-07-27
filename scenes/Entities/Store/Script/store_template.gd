extends Node3D
class_name StoreTemplate

@onready var items_container: Node3D = $StorePurchasedItems
@onready var my_component_container: component_container = $StoreControlePanel/ComponentContainer

func add_new_store_item(store_item:Node)->void:
	if is_multiplayer_authority():
		items_container.add_child(store_item)
