class_name data_to_save_time_manager

extends data_to_save_custom

const PRELOAD_CUSTOM = preload("uid://c2di55v3108hj")

var time: float = 0.0

func save_properties(root:Node, custom:Node = null, inIsGlobal = false)->void:
	if isGlobal:
		time = GlobalTime.time
		return
	super.save_properties(root, custom, inIsGlobal)

func load_properties(_root:Node = null, _custom:Node = null)->void:
	GlobalTime.setTime(time)

func get_preload()->Resource:
	return PRELOAD_CUSTOM
