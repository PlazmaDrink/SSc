extends CharacterBody2D

@onready var loads_container: Node = $"../LoadList/LoadsContainer"

var scrolling = false
var offset = Vector2(0,0)

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position() - offset
	if scrolling:
		loads_container.position.y = mouse_pos.y
	move_and_slide()
