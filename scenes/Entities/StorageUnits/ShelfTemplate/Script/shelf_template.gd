extends Node3D


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

func onInventoryUpdated()->void:
	for slot in inventory_ref.slots:
		if slot.is_empty(): continue
		_sync_items_with_inventory(slot)
		print_debug(slot.item_id)

func _sync_items_with_inventory(inInv_slot: InventorySlot)->void:
	var targetLocation = locationMarkers[inInv_slot.slot_index]
	for child in targetLocation.get_children():
		child.queue_free()
	var item:Item = ItemDatabase.get_item(inInv_slot.item_id)
	var assetScene = preload(item.getAssetByQuantity(inInv_slot.quantity))
	
