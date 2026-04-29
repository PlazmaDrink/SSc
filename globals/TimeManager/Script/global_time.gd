extends Node3D

const MIN_PER_DAY:int = 1440
const MIN_PER_HOUR:int = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2*PI) / MIN_PER_HOUR

##This value influence real/in-game time dependancy. Value 12 means 1sec=1min in game. Lower the value faster the in-game time
@export var realtime_multiplier:int = 12

##Time calculated with adding delta (Saved/Loaded)
@export var time: float = 0.0:
	get:
		return time

var past_min: float = -1.0
##Number of minutes past since start of the game (Saved/Loaded)
var total_minutes = int(time/INGAME_TO_REAL_MINUTE_DURATION)

##Number of full days past in total (Saved/Loaded)
@warning_ignore("integer_division")
var total_days_count = int (total_minutes/ MIN_PER_DAY)

##Amount of minutes since midnight (Saved/Loaded)
@export var current_day = total_minutes % MIN_PER_DAY

@warning_ignore("integer_division")
var current_hour = current_day/MIN_PER_HOUR
var current_min = int(current_day % MIN_PER_HOUR)


signal time_tick(day:int, hour:int, minute:int)

func _enter_tree() -> void:
	set_multiplayer_authority(1)
	
func _process(delta: float) -> void:
	if is_multiplayer_authority():
		time += delta
		_recalculatetime.rpc()

func setTime(value:float):
	if multiplayer.is_server():
		time = value
		_recalculatetime()

func add_time(day:int = 0, hour:int = 0, minute:int = 0, isSetTime = false) -> void:
	day *= MIN_PER_DAY
	hour *= MIN_PER_HOUR
	var newTime:float = (day + hour + minute) * INGAME_TO_REAL_MINUTE_DURATION * realtime_multiplier
	if isSetTime:
		time = newTime
	else:
		time += newTime
	_recalculatetime()

@rpc("authority", "call_local")
func _recalculatetime() -> void:
	@warning_ignore("integer_division")
	total_minutes = int(time/INGAME_TO_REAL_MINUTE_DURATION) / realtime_multiplier
	
	@warning_ignore("integer_division")
	total_days_count = int (total_minutes/ MIN_PER_DAY)
	current_day = total_minutes % MIN_PER_DAY
	@warning_ignore("integer_division")
	current_hour = int(current_day/MIN_PER_HOUR)
	current_min = int(current_day % MIN_PER_HOUR)
	
	if past_min != current_min:
		past_min = current_min
		time_tick.emit(current_day, current_hour, current_min)
