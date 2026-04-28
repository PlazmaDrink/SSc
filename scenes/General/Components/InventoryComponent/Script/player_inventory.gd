class_name PlayerInventory
extends Inventory

var current_player: Player_Character

func update_inventory_display():
	if not current_player or not current_player.component_container.get_component(GameEnums.Components.InventoryComponent).get_inventory():
		return
