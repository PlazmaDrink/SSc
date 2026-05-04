class_name Interaction_Inventory
extends Interaction

func on_interaction(componentContainer: component_container):
	if GlobalData.UI_manager:
		GlobalData.UI_manager.inventory_ui.add_non_player_inventory_to_viewport\
		(componentContainer.get_component(GameEnums.Components.InventoryComponent).get_inventory(),componentContainer.root_node.name)
