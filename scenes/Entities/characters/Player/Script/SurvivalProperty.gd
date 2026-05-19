class_name SurvivalProperty
extends Resource

@export var property_name:String
@export var property_value:float
@export var property_time_step: float
@export var property_last_time_footprint: float

func _init(in_property_name: String, in_property_time_step: float, in_property_value: int = 100, in_property_last_time_footprint: int = 0):
	property_name = in_property_name
	property_value = in_property_value
	property_time_step = in_property_time_step
	property_last_time_footprint = in_property_last_time_footprint
