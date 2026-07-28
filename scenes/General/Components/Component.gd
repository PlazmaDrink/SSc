class_name Component
extends Node

@export var my_component_type:GameEnums.Components
var my_component_container

func initiate_component()->void:
	pass

func set_component_container(inComponentContainer:component_container)->void:
	my_component_container = inComponentContainer
