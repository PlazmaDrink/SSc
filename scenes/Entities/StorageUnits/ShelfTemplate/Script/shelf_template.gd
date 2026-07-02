extends Node3D

## Choose what kind of items can be stored here
@export var myShelfType:GameEnums.ItemTypes
@onready var my_component_container: component_container = $ComponentContainer
var inventory_ref: Inventory

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	my_component_container.initiate_component_container()
	var inv_comp:Inventory_component = my_component_container.get_component(GameEnums.Components.InventoryComponent)
	inventory_ref = inv_comp.get_inventory()
	inventory_ref.Request_UI_Update.connect(onInventoryUpdated)

func onInventoryUpdated()->void:
	print_debug("Shelf want update!!!!")
	pass
