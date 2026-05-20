extends Node3D

signal InteractInput()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact"):
		InteractInput.emit()
