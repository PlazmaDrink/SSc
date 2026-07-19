class_name Survival_component
extends Component

var _hunger: SurvivalProperty = SurvivalProperty.new("hunger", 15)
var _thirst: SurvivalProperty = SurvivalProperty.new("thirst", 24)
var _sleep: SurvivalProperty = SurvivalProperty.new("sleep", 30)

var _survi_properties: Array[SurvivalProperty] = [_hunger, _thirst, _sleep]

signal value_changed(new_value:SurvivalProperty)
# Called when the node enters the scene tree for the first time.
func initiate_component()->void:
	GlobalTime.time_tick.connect(_on_time_tick)

func alter_property(property, value)->void:
	property.property_value += value
	if property.property_last_time_footprint != abs(value):
		value_changed.emit(property)

func _on_time_tick(current_day, _current_hour, _current_min):
	for property in _survi_properties:
		var current_value = current_day/property.property_time_step
		if property.property_last_time_footprint != current_value:
			alter_property(property, property.property_last_time_footprint - current_value)
			property.property_last_time_footprint = current_value
