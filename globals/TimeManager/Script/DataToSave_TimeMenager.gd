class_name DataToSave_TimeMenager

extends DataToSave

const PRELOAD_CUSTOM = preload("uid://c2di55v3108hj")

var time: float = 0.0

func save_properties()->void:
	if isGlobal:
		time = GlobalTime._time
		return
	super.save_properties()

func load_properties()->void:
	if isGlobal:
		GlobalTime.setTime(time)
		return
	super.load_properties()

func get_preload()->Resource:
	return PRELOAD_CUSTOM
