extends Node

var CurrentTime:float = 0
var isBusy:bool = false

signal ActionFinished

var action_Finish_Time: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalTime.time_tick.connect(on_time_tick)
	set_timer(10)
	
func set_timer(wait_time:int) ->void:
	action_Finish_Time = GlobalTime.current_day + wait_time
	isBusy = true

func on_time_tick(time_of_day:int, hour:int, minute:int)-> void:
	if isBusy:
		CheckIsActionComplete(time_of_day)

func CheckIsActionComplete(time:int) -> void:
	if GlobalTime.current_day >= action_Finish_Time:
		isBusy = false
		action_Finish_Time = -1
		ActionFinished.emit()
