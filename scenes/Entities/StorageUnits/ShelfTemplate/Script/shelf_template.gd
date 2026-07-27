extends Node3D

@export var store_item_scene:PackedScene

@export_category("Storage Settings")
## Choose what kind of items can be stored here
@export var myShelfType:StorageUnit
@export var locationMarkers:Array[Marker3D]
@onready var my_component_container: component_container = $ComponentContainer
var inventory_ref: Inventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	my_component_container.initiate_component_container()
	var inv_comp:Inventory_component = my_component_container.get_component(GameEnums.Components.InventoryComponent)
	inventory_ref = inv_comp.get_inventory()
	inventory_ref.Request_UI_Update.connect(onInventoryUpdated)
	var store_item_inst = store_item_scene.instantiate()
	add_child(store_item_inst)

func onInventoryUpdated()->void:
	for slot in inventory_ref.slots:
		if slot.is_empty(): continue
		_sync_items_with_inventory(slot)
		print_debug(slot.item_id)

#TODO: Its updating every time. Needs optimisation + safe check for null
func _sync_items_with_inventory(inInv_slot: InventorySlot)->void:
	var item = ItemDatabase.get_item(inInv_slot.item_id)
	var item_scene: PackedScene = item.getAsset(inInv_slot.quantity)
	if item_scene:
		var item_instance = item_scene.instantiate()
		var targetMarker = locationMarkers.get(inInv_slot.slot_index)
		if targetMarker:
			item_instance.position = targetMarker.position
			targetMarker.add_child(item_instance)
	
	
