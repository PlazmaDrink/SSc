extends Node3D

const MIN_PER_DAY:int = 1440
const MIN_PER_HOUR:int = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2*PI) / MIN_PER_HOUR

var time: float = 0.0
var past_min: float = -1.0
signal time_tick(day:int, hour:int, minute:int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	var value = (sin(time - PI/2) + 1.0)/2.0
	_recalculate_time()

func _recalculate_time() -> void:
	var total_minutes = int(time/INGAME_TO_REAL_MINUTE_DURATION)
	
	var day = int (total_minutes/ MIN_PER_DAY)
	var current_day = total_minutes % MIN_PER_DAY
	var current_hour = int(current_day/MIN_PER_HOUR)
	var current_min = int(current_day % MIN_PER_HOUR)
	
	if past_min != current_min:
		past_min = current_min
		time_tick.emit(current_day, current_hour, current_min)
