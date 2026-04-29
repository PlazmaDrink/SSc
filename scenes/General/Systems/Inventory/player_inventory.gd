class_name PlayerInventory
extends Inventory

var current_player: Player_Character

func try_if_local()->bool:
	if current_player:
		return true
	else:
		return false
