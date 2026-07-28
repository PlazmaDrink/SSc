extends Node3D
class_name StoreTemplate

const PREVIEW_COMPONENT = preload("uid://cpc13ap3bgilr")

@onready var my_component_container: component_container = $StoreControlePanel/ComponentContainer
@onready var store_interior_items: Node3D = $StoreInteriorItems

func spawn_store_item(inStoreItem:StoreItem)->void:
	var scene = inStoreItem.getAsset()
	var item = scene.instantiate()
	store_interior_items.add_child(item)
	
	var preview_component = PREVIEW_COMPONENT.instantiate()
	item.my_component_container.add_child(preview_component)
	preview_component.set_preview_bonds(CameraManager.update_camera_bounds(self))
