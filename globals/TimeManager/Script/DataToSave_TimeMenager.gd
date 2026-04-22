class_name DataToSave_TimeMenager

extends DataToSave_Custom

const PRELOAD_CUSTOM = preload("uid://c2di55v3108hj")

var time: float = 0.0

func save_properties(root:Node, custom:Node = null, isGlobal = false)->void:
	if isGlobal:
		time = GlobalTime._time
		return
	super.save_properties(root, custom, isGlobal)

func load_properties(root:Node = null, custom:Node = null)->void:
	GlobalTime.setTime(time)

func get_preload()->Resource:
	return PRELOAD_CUSTOM
