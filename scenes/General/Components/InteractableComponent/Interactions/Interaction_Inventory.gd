class_name Interaction_Inventory
extends Interaction
 #TODO: this node must inform UI_manager that contaibers inventory is requested 
func on_interaction(componentContainer: component_container):
	if GlobalData.UI_manager:
		GlobalData.UI_manager.add_non_player_inventory_to_viewport(componentContainer.get_component(GameEnums.Components.InventoryComponent).get_inventory())
