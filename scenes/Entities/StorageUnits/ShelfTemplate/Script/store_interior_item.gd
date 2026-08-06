extends Node3D
class_name store_interior_item
const PREVIEW_COMPONENT = preload("uid://cpc13ap3bgilr")

@export var store_item_scene:PackedScene

@export_category("Storage Settings")
## Choose what kind of items can be stored here
@export var myShelfType:StorageUnit
@onready var my_component_container: component_container = $ComponentContainer
var inventory_ref: Inventory
var canBePlaced:bool = true
var store_item_inst: Node
var parent_store:StoreTemplate = null
var snapingPoints:Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent_store.on_item_spawned.connect(_on_item_spawned)
	parent_store.on_item_placed.connect(_on_item_placed)
	
	my_component_container.initiate_component_container()
	var inv_comp:Inventory_component = my_component_container.get_component(GameEnums.Components.InventoryComponent)
	inventory_ref = inv_comp.get_inventory()
	
	#Create and add an instance of asset scene
	store_item_inst = store_item_scene.instantiate()
	add_child(store_item_inst)
	#Set Mesh to outline
	my_component_container.get_component(GameEnums.Components.InteractableComponent).set_target_to_outline(store_item_inst)
	#Set snapping points of this object
	for point in store_item_inst.snapping_points.get_children():
		snapingPoints.append(point)
	
	var preview_component = PREVIEW_COMPONENT.instantiate()
	my_component_container.add_child(preview_component)
	preview_component.set_preview_bonds(CameraManager.update_camera_bounds(parent_store))

func _on_item_spawned()->void:
	pass

func _on_item_placed()->void:
	place_item()
	if !inventory_ref.Request_UI_Update.is_connected(onInventoryUpdated):
		inventory_ref.Request_UI_Update.connect(onInventoryUpdated)
	onInventoryUpdated()

func onInventoryUpdated()->void:
	for slot in inventory_ref.slots:
		if slot.is_empty(): continue
		_sync_items_with_inventory(slot)

#TODO: Its updating every time. Needs optimisation + safe check for null
func _sync_items_with_inventory(inInv_slot: InventorySlot)->void:
	var item = ItemDatabase.get_item(inInv_slot.item_id)
	var item_scene: PackedScene = item.getAsset(inInv_slot.quantity)
	if item_scene:
		var item_instance = item_scene.instantiate()
		var targetMarker = store_item_inst.locationMarkers.get(inInv_slot.slot_index)
		if targetMarker:
			#item_instance.position = targetMarker.position
			targetMarker.add_child(item_instance)
			item_instance.global_position = targetMarker.global_position

func set_canBePlaced(input:bool)->void:
	canBePlaced = input

func place_item()->void:
	if canBePlaced:
		#turn of preview component process func
		var preview_comp_ref = my_component_container.get_component(GameEnums.Components.PreviewComponent)
		preview_comp_ref.place_item()

func rotate_self(inRotationDir:float)->void:
	var rotation_speed = 10 * get_process_delta_time()
	rotate_object_local(Vector3.UP, inRotationDir * rotation_speed)
