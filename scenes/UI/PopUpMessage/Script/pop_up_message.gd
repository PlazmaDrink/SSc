extends CustomControl

@onready var window_name_label: Label = $ColorRect/VBoxContainer/WindowNameLabel
@onready var message_label: Label = $ColorRect/VBoxContainer/MessageLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func update_pop_up_message(topLabel:String, messageLabel:String) ->void:
	window_name_label.text = topLabel
	message_label.text = messageLabel

func _on_close_button_pressed() -> void:
	queue_free()
