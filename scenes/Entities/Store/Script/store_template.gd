extends Node3D
class_name StoreTemplate

const PREVIEW_COMPONENT = preload("uid://cpc13ap3bgilr")
const SHELF_TEMPLATE = preload("uid://0on3ilotj8xf")

@onready var my_component_container: component_container = $StoreControlePanel/ComponentContainer
@onready var store_interior_items: Node3D = $StoreInteriorItems

##This var is ref to item that is currently in preview mode
var item_currently_in_preview:Node3D = null

func spawn_store_item(inStoreItem:StoreItem)->void:
	var scene = inStoreItem.getAsset()
	var item = SHELF_TEMPLATE.instantiate()
	item.store_item_scene = scene
	store_interior_items.add_child(item)
	
	var preview_component = PREVIEW_COMPONENT.instantiate()
	item.my_component_container.add_child(preview_component)
	preview_component.set_preview_bonds(CameraManager.update_camera_bounds(self))
	#assigne ref to temp var
	item_currently_in_preview = item
