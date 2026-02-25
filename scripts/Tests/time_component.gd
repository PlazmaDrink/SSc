extends Node

var CurrentTime:float = 0
var isBusy:bool = false

signal ActionFinished

var action_Finish_Time: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalTime.update_current_time.connect(on_update_current_time)
	set_timer(10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isBusy:
		CheckIsActionComplete()
	
func set_timer(wait_time:int) ->void:
	action_Finish_Time = GlobalTime.current_day + wait_time
	isBusy = true

func on_update_current_time(current_time: int)-> void:
	if isBusy:
		CheckIsActionComplete()

func CheckIsActionComplete() -> void:
	if GlobalTime.current_day >= action_Finish_Time:
		isBusy = false
		action_Finish_Time = -1
		ActionFinished.emit()
