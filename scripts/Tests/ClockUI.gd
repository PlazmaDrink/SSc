extends TextEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalTime.time_tick.connect(_update_time)

func _update_time(current_day, current_hour, current_min):
	text = "%s : %s" % [current_hour, current_min]
	pass
