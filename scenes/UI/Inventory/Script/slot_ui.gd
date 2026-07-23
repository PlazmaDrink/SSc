extends Control
class_name SlotUI

signal slot_clicked(slot_index: int, button: int)

@onready var background: NinePatchRect = $Background
@onready var item_icon: TextureRect = $ItemIcon

var slot_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed:
			slot_clicked.emit(slot_index, event.button_index)

func _on_mouse_entered():
	#TODO: what default behavior should be?
	background.modulate = Color(1.2, 1.2, 1.2)

func _on_mouse_exited():
	background.modulate = Color.WHITE
