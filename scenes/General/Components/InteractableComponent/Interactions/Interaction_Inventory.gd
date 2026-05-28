class_name Interaction_Inventory
extends Interaction

var required_component = GameEnums.Components.InventoryComponent

func on_interaction(componentContainer: component_container):
	GlobalData.get_local_player().game_state.UI_manager.add_non_player_inventory_to_viewport\
	(componentContainer.get_component(required_component).get_inventory(),componentContainer.root_node.name)
