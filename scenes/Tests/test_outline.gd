extends Node3D

@onready var component_container: Node = $"../ComponentContainer"

func raytrace_enter()->void:
	component_container.send_message_to_child("InteractableComponent","raytrace_enter")

func raytrace_exit()->void:
	component_container.send_message_to_child("InteractableComponent","raytrace_exit")
