class_name Inventory_component
extends Node

@export var inventory_size:int = 20
var owner_inventory:Inventory
var root_node: Node
var isPlayerInventory:bool = true
# Called when the node enters the scene tree for the first time.

func initiate_component()->void:
	root_node = get_parent().root_node
	if root_node is Player_Character:
		if root_node.is_multiplayer_authority():
			owner_inventory = PlayerInventory.new(self, inventory_size)
			_add_starting_items()
		elif multiplayer.is_server():
			owner_inventory = PlayerInventory.new(self, inventory_size)
			_add_starting_items()
		else:
			if root_node.get_multiplayer_authority() == root_node.local_client_id:
				request_inventory_sync.rpc_id(1)
		return
	else:
		isPlayerInventory = false
		owner_inventory = Inventory.new(self, inventory_size)
		_add_starting_items()

func _add_starting_items():
	if not owner_inventory:
		return

	var sword = ItemDatabase.get_item("iron_sword")
	var potion = ItemDatabase.get_item("health_potion")

	if sword:
		owner_inventory.add_item(sword, 1)
	if potion:
		owner_inventory.add_item(potion, 3)

# Inventory Network Functions - Server authoritative, client-specific
@rpc("any_peer", "call_local", "reliable")
func request_inventory_sync():
	print("Debug: request_inventory_sync called on player ", name, " (authority: ", get_multiplayer_authority(), ") by client ", multiplayer.get_remote_sender_id())
	if not multiplayer.is_server():
		return

	var requesting_client = multiplayer.get_remote_sender_id()
	if isPlayerInventory:
		if requesting_client != get_multiplayer_authority():
			return

		if owner_inventory:
			sync_inventory_to_all.rpc_id(requesting_client, owner_inventory.to_dict())
	else:
		if owner_inventory:
			sync_inventory_to_all.rpc(owner_inventory.to_dict())

@rpc("any_peer", "call_local", "reliable")
func sync_inventory_to_all(inventory_data: Dictionary):
	print("Debug: sync_inventory_to_owner called on player ", name, " (authority: ", get_multiplayer_authority(), ") - local unique id: ", multiplayer.get_unique_id(), " from: ", multiplayer.get_remote_sender_id())
	if multiplayer.get_remote_sender_id() != 1:
		return
	if isPlayerInventory:
		if not is_multiplayer_authority():
			return
		if not owner_inventory:
			owner_inventory = PlayerInventory.new(self)
		owner_inventory.from_dict(inventory_data)
		owner_inventory.on_Request_UI_Update()
	else:
		if not owner_inventory:
			owner_inventory = Inventory.new(self)
		owner_inventory.from_dict(inventory_data)

@rpc("any_peer", "call_remote", "reliable")
func request_move_item(source_inv_id:String, from_slot: int, item_id: String, to_slot: int, quantity: int):
	if owner_inventory is PlayerInventory:
		print("Debug: request_move_item called - from:", from_slot, " to:", to_slot, " on player ", name, " (authority: ", get_multiplayer_authority(), ") by client ", multiplayer.get_remote_sender_id())
		if not multiplayer.is_server():
			return
		var requesting_client = multiplayer.get_remote_sender_id()
		if requesting_client != get_multiplayer_authority():
			push_warning("Client " + str(requesting_client) + " tried to modify inventory for player " + str(get_multiplayer_authority()))
			return
		if not owner_inventory:
			return
		if from_slot < 0 or from_slot >= owner_inventory.inventory_size or to_slot < 0 or to_slot >= owner_inventory.inventory_size:
			push_warning("Invalid slot indices: from=" + str(from_slot) + " to=" + str(to_slot))
			return
	move_item(source_inv_id, from_slot, item_id, to_slot, quantity)

func move_item(source_inv_id:String, from_slot: int, item_id: String, to_slot: int, quantity: int)->void:
	var success = false
	if owner_inventory.inventory_id == source_inv_id:
		# 1. Moving items within the exact same inventory
		if quantity == -1:
			success = owner_inventory.move_item(from_slot, item_id, to_slot, quantity)
			if not success:
				success = owner_inventory.swap_items(from_slot, to_slot)
				print("Debug: Swapped items between slots ", from_slot, " and ", to_slot)
			else:
				print("Debug: Moved item from slot ", from_slot, " to ", to_slot)
		else:
			success = owner_inventory.move_item(from_slot, item_id, to_slot, quantity)
			print("Debug: Moved ", quantity, " items from slot ", from_slot, " to ", to_slot)

		if success:
			print("Debug: Move successful, syncing inventory to owner ", get_multiplayer_authority())
			sync_inventory_to_all.rpc(owner_inventory.to_dict())
		else:
			print("Debug: Move/swap failed")
	else:
		# 1. Moving items from one inventory to another inventory
		var source_component = get_node_or_null(source_inv_id)
		if not source_component:
			return   
		var source_inventory = source_component.get_inventory()
		var actual_quantity = quantity
		if quantity == -1:
			actual_quantity = source_inventory.get_slot(from_slot).quantity   
		var remaining = owner_inventory.add_item(ItemDatabase.get_item(item_id), actual_quantity)
		var successfully_added = actual_quantity - remaining
		if successfully_added > 0:
			source_inventory.remove_item(item_id, successfully_added, from_slot)
			# Sync BOTH inventories to all clients
			sync_inventory_to_all.rpc(owner_inventory.to_dict())
			source_component.sync_inventory_to_all.rpc(source_inventory.to_dict())

@rpc("any_peer", "call_local", "reliable")
func request_add_item(slot: InventorySlot):
	print("Debug: request_add_item called on player ", name, " (authority: ", get_multiplayer_authority(), ") by client ", multiplayer.get_remote_sender_id())

	if not multiplayer.is_server():
		return

	var requesting_client = multiplayer.get_remote_sender_id()
	if requesting_client != get_multiplayer_authority() and requesting_client != 1 and owner_inventory is PlayerInventory:
		push_warning("Client " + str(requesting_client) + " tried to add items to player " + str(get_multiplayer_authority()))
		return

	if not owner_inventory:
		return

	if slot.quantity <= 0:
		push_warning("Invalid quantity: " + str(slot.quantity))
		return

	var item = ItemDatabase.get_item(slot.item_id)
	if not item:
		push_warning("Item not found: " + slot.item_id)
		return

	var remaining = owner_inventory.add_item(item, slot.quantity)
	var added = slot.quantity - remaining
	print("Debug: Added ", added, " ", slot.item_id, " to inventory (", remaining, " remaining)")

	if added > 0:
		var owner_id = get_multiplayer_authority()
		print("Debug: Syncing inventory to owner ", owner_id)
		if owner_id != 1:
			sync_inventory_to_all.rpc_id(owner_id, owner_inventory.to_dict())
		else:
			GlobalData.UI_manager.inventory_ui.update_inventory_display()

@rpc("any_peer", "call_local", "reliable")
func request_remove_item(slot: InventorySlot):
	print("Debug: request_remove_item called on player ", name, " (authority: ", get_multiplayer_authority(), ") by client ", multiplayer.get_remote_sender_id())

	if not multiplayer.is_server():
		return

	var requesting_client = multiplayer.get_remote_sender_id()
	if requesting_client != get_multiplayer_authority() and owner_inventory is PlayerInventory:
		push_warning("Client " + str(requesting_client) + " tried to remove items from player " + str(get_multiplayer_authority()))
		return

	if not owner_inventory:
		return

	if slot.quantity <= 0:
		push_warning("Invalid quantity: " + str(slot.quantity))
		return

	var removed = owner_inventory.remove_item(slot.item_id, slot.quantity)

	if removed > 0:
		var owner_id = get_multiplayer_authority()
		if owner_id != 1:
			sync_inventory_to_all.rpc_id(owner_id, owner_inventory.to_dict())
		else:
			GlobalData.UI_manager.inventory_ui.update_inventory_display()

func get_inventory() -> Inventory:
	return owner_inventory
