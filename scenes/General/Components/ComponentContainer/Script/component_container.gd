extends Node

##Array of all components of this scene
var components_list: Array
# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
		_initiate_component_array()

func _initiate_component_array()->void:
	components_list = get_children()

func send_message_to_child(child_name:String, func_name:String)->void:
	for item in components_list:
		if item.name == child_name:
			item.call(func_name)
			break

func get_component(componentName:String)->Node:
	for item in components_list:
		if item.name == componentName:
			return item
	return null
