class_name DataToSave_TimeMenager

extends DataToSave_Custom

const PRELOAD_CUSTOM = preload("uid://c2di55v3108hj")

var time: float = 0.0

func save_properties(root:Node, custom:Node = null, inIsGlobal = false)->void:
	if isGlobal:
		time = GlobalTime._time
		return
	super.save_properties(root, custom, inIsGlobal)

func load_properties(_root:Node = null, _custom:Node = null)->void:
	GlobalTime.setTime(time)

func get_preload()->Resource:
	return PRELOAD_CUSTOM
