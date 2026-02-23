extends Node

var CurrentTime:float = 0
var isBusy:bool = false

@onready var timer: Timer = $Timer

signal ActionStart(timerValue: int)
signal ActionFinished

var action_Start_Time: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalTime.update_current_time.connect(on_update_current_time)
	set_timer(5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_timer(wait_time:int) ->void:
	timer.wait_time = wait_time
	timer.start()
	action_Start_Time = GlobalTime.current_day

func _on_timer_timeout() -> void:
	print("Timer finished")
	ActionFinished.emit()

func on_update_current_time(current_time: int)-> void:
	print(current_time)
