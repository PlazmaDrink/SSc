class_name component_container
extends Node

##Array of all components of this instance
var components_dict: Dictionary = {}
var root_node:Node
var is_initialized:bool = false
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	_check_auto_init.call_deferred()

## In case if parent node doesn't initiate this node
func _check_auto_init() -> void:
	if is_initialized: return # Parent already handled it!
	initiate_component_container()

func initiate_component_container()->void:
	if !is_initialized:
		for item in GameEnums.Components:
			if get_node_or_null(String(item)):
				components_dict[item] = get_node(String(item))
		root_node = get_parent()
		initiate_children_components()
		is_initialized = true

func initiate_children_components()->void:
	for component in components_dict:
		components_dict.get(component).set_component_container(self)
		components_dict.get(component).initiate_component()

func send_message_to_component(inComponent:GameEnums.Components, func_name:String)->void:
	var component = components_dict.get(GameEnums.Components.keys()[inComponent])
	if component:
		component.call(func_name)

func get_component(inComponent:GameEnums.Components)->Node:
	var component = components_dict.get(GameEnums.Components.keys()[inComponent])
	if component:
		return component
	return null

##Add component to dict if it was added after initialization of container
func _on_child_entered_tree(node: Node) -> void:
	if is_initialized:
		components_dict[GameEnums.Components.find_key(node.my_component_type)] = node
		node.set_component_container(self)
		node.initiate_component()
