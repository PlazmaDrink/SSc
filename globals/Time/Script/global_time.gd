extends Node3D

const MIN_PER_DAY:int = 1440
const MIN_PER_HOUR:int = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2*PI) / MIN_PER_HOUR

##This value influence real/in-game time dependancy. Value 12 means 1sec=1min in game. Lower the value faster the in-game time
@export var real_time_multiplier:int = 12
@export var time: float = 0.0

var past_min: float = -1.0
var total_minutes = int(time/INGAME_TO_REAL_MINUTE_DURATION)
var total_day = int (total_minutes/ MIN_PER_DAY)
@export var current_day = total_minutes % MIN_PER_DAY
var current_hour = int(current_day/MIN_PER_HOUR)
var current_min = int(current_day % MIN_PER_HOUR)


signal time_tick(day:int, hour:int, minute:int)
#signal update_current_time(current_time:int)

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	set_multiplayer_authority(1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_multiplayer_authority():
		time += delta
		#var value = (sin(time - PI/2) + 1.0)/2.0
		_recalculate_time.rpc()

@rpc("authority", "call_local")
func _recalculate_time() -> void:
	total_minutes = int(time/INGAME_TO_REAL_MINUTE_DURATION) / real_time_multiplier
	
	total_day = int (total_minutes/ MIN_PER_DAY)
	current_day = total_minutes % MIN_PER_DAY
	current_hour = int(current_day/MIN_PER_HOUR)
	current_min = int(current_day % MIN_PER_HOUR)
	
	if past_min != current_min:
		past_min = current_min
		time_tick.emit(current_day, current_hour, current_min)

func add_time(day:int = 0, hour:int = 0, minute:int = 0, isSetTime = false) -> void:
	day *= MIN_PER_DAY
	hour *= MIN_PER_HOUR
	var newTime:float = (day + hour + minute) * INGAME_TO_REAL_MINUTE_DURATION * real_time_multiplier
	if isSetTime:
		time = newTime
	else:
		time += newTime
	_recalculate_time()
	#update_current_time.emit(current_day)
