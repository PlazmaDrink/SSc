class_name Interaction_PickUp_Item
extends Interaction

@export var pickupItem:Item

var required_component = GameEnums.Components.InventoryComponent

func on_interaction(componentContainer: component_container)->void:
	var players_container = GlobalData.get_local_player().my_component_container
	players_container.get_component(required_component).get_inventory().add_item(pickupItem, 1)
	
	componentContainer.get_parent().queue_free()
