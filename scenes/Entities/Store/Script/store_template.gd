extends Node3D
class_name StoreTemplate

signal on_item_spawned
signal on_item_placed

##TODO: change shelf_template to store_item_template (shelf template will be a subclass of it)
const SHELF_TEMPLATE = preload("uid://0on3ilotj8xf")

@onready var my_component_container: component_container = $StoreControlePanel/ComponentContainer
@onready var store_interior_items: Node3D = $StoreInteriorItems

##This var is ref to item that is currently in preview mode
var item_currently_in_preview:Node3D = null

func spawn_store_item(inStoreItem:StoreItem)->void:
	var item = SHELF_TEMPLATE.instantiate()
	item.parent_store = self
	var scene = inStoreItem.getAsset()
	item.store_item_scene = scene
	store_interior_items.add_child(item)
	
	#assigne ref to temp var
	item_currently_in_preview = item
	on_item_spawned.emit()

func try_to_place_item()->void:
	if item_currently_in_preview:
		if item_currently_in_preview.canBePlaced:
			on_item_placed.emit()
			item_currently_in_preview = null

func rotate_current_item(inRotationDir:float)->void:
	if item_currently_in_preview:
		item_currently_in_preview.rotate_self(inRotationDir)
