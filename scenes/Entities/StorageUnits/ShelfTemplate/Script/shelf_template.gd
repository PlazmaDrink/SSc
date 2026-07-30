extends Node3D

@export var store_item_scene:PackedScene

@export_category("Storage Settings")
## Choose what kind of items can be stored here
@export var myShelfType:StorageUnit
@export var locationMarkers:Array[Marker3D]
@onready var my_component_container: component_container = $ComponentContainer
var inventory_ref: Inventory
var canBePlaced:bool = true

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

func set_canBePlaced(input:bool)->void:
	canBePlaced = input

func try_to_place_item()->bool:
	if canBePlaced:
		#turn of preview component process func
		var preview_comp_ref = my_component_container.get_component(GameEnums.Components.PreviewComponent)
		preview_comp_ref.set_origin_mat_to_mesh()
		preview_comp_ref.update_process_node(Node.PROCESS_MODE_DISABLED)
		return true
	return false

func rotate_self(inRotationDir:float)->void:
	var rotation_speed = 10 * get_process_delta_time()
	rotate_object_local(Vector3.UP, inRotationDir * rotation_speed)
