extends Control
class_name UI_Time_Control

@onready var add_time_input: LineEdit = $ColorRect/MainContainer/TimeMenu/Option1/AddTimeInput
@onready var time_value: Label = $ColorRect/MainContainer/TimeValue
@onready var set_time_input: LineEdit = $ColorRect/MainContainer/TimeMenu/Option2/SetTimeInput

signal on_Close
var addTime: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalTime.time_tick.connect(on_time_tick)
	hide_menu()

func on_time_tick(_current_day: int, current_hour: int, current_min:int)-> void:
	time_value.text = "%s : %s" % [current_hour, current_min]
	
func _on_add_time_pressed() -> void:
	GlobalTime.add_time(0,0,addTime)


func _on_set_time_pressed() -> void:
	var input = set_time_input.text.split(":")
	var hours:int = int(input[0])
	var minute:int = int(input[1])
	GlobalTime.add_time(0, hours, minute, true)

func _on_close_pressed() -> void:
	hide_menu()
	on_Close.emit()

func _on_add_time_input_text_changed(new_text: String) -> void:
	addTime = int(new_text)

func show_menu():
	show()

func hide_menu():
	hide()
	
func is_menu_visible() -> bool:
	return visible
	
func open_UI_time_menu(player: Player_Character = null):
	if player:
		visible = true
