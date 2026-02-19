extends Node3D

@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var sun: DirectionalLight3D = $DirectionalLight3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalTime.time_tick.connect(on_time_tick)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_time_tick(_current_day, _current_hour, _current_min)-> void:
	sun_rotation(_current_day)

##Sets directional light rotation based on in-game time(sun movement imitation)
func sun_rotation(current_time:int)-> void:
	sun.set_rotation_degrees(Vector3(current_time * 0.25 - 180,0,0))
