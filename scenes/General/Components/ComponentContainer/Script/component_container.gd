class_name component_container
extends Node

##Array of all components of this instance
var components_dict: Dictionary = {}
var root_node:Node
# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	get_parent().ready.connect(_on_parent_ready)

func _on_parent_ready()->void:
		_initiate_components_dict()
		root_node = get_parent()

func _initiate_components_dict()->void:
	for item in GameEnums.Components:
		if get_node_or_null(String(item)):
			components_dict[item] = get_node(String(item))

func send_message_to_component(inComponent:GameEnums.Components, func_name:String)->void:
	var component = components_dict.get(GameEnums.Components.keys()[inComponent])
	if component:
		component.call(func_name)

func get_component(inComponent:GameEnums.Components)->Node:
	var component = components_dict.get(GameEnums.Components.keys()[inComponent])
	if component:
		return component
	return null
