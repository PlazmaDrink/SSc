extends CustomControl
class_name Store_UI

@onready var store_slot_container: HBoxContainer = $StoreItems/MarginContainer/VBoxContainer/HBoxContainer

var slot_ui_scene: PackedScene
var slot_uis: Array[StoreSlotUI] = []
var store_ref:StoreTemplate

func initiane_UI_element()->void:
	slot_ui_scene = preload("uid://bglwdpf2mf7g0")
	set_process_input(true)
	_create_store_slot_uis()
	hide()

func toggle_visibility()->void:
	visible = !visible
	if visible:
		show()
		mouse_filter = Control.MOUSE_FILTER_PASS
	else:
		hide()
		get_viewport().set_input_as_handled()

func _on_exit_pressed() -> void:
	var local_player = GlobalData.get_local_player()
	var camera_component = local_player.my_component_container.get_component(GameEnums.Components.CameraComponent)
	camera_component.cameraTransition()
	toggle_visibility()

func _create_store_slot_uis():
	for child in store_slot_container.get_children():
		child.queue_free()
	slot_uis.clear()
	var item_index:int = 0
	for i in ItemDatabase.store_items:
		var slot_ui = slot_ui_scene.instantiate() as StoreSlotUI
		slot_ui.custom_minimum_size = Vector2(128, 128)
		slot_ui.slot_clicked.connect(_on_slot_clicked)

		slot_ui.set_store_slot_data(ItemDatabase.store_items.get(i), item_index)
		item_index+= 1
		store_slot_container.add_child(slot_ui)
		slot_uis.append(slot_ui)

func _on_slot_clicked(slot_index: int, button: int):
	if is_multiplayer_authority():
		print_debug("Slot ", slot_index, " clicked with button ", button)
		var clicked_slot = slot_uis.get(slot_index)
		var store_item = clicked_slot.store_item
		store_ref.spawn_store_item(store_item)
