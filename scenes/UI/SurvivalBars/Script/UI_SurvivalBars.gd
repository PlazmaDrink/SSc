extends Control

@onready var hunger_bar: ProgressBar = $ColorRect/VBoxContainer/HungerBar
@onready var thirst_bar: ProgressBar = $ColorRect/VBoxContainer/ThirstBar
@onready var sleep_bar: ProgressBar = $ColorRect/VBoxContainer/SleepBar

var playersSurvivalComponent: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_multiplayer_authority():
		pass
		#var temp:Array = get_tree().get_nodes_in_group("Player")
		#playersSurvivalComponent = temp[0].getComponentContainer().get_component("SurvivalComponent")
		#playersSurvivalComponent.value_changed.connect(on_new_bar_value)

func on_new_bar_value(survivalProperty:SurvivalProperty)->void:
	if survivalProperty.property_name == "hunger":
		hunger_bar.value = survivalProperty.property_value
	if survivalProperty.property_name == "thirst":
		thirst_bar.value = survivalProperty.property_value
	if survivalProperty.property_name == "sleep":
		sleep_bar.value = survivalProperty.property_value
