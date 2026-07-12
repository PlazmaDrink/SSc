extends Control
class_name CustomControl

@export var UI_Manager_Ref: UI_Manager

func _ready() -> void:
	pass
	#visibility_changed.connect(OnVisibilityChange)
##Deprecated
#func OnVisibilityChange()->void:
	#if UI_Manager_Ref:
		#UI_Manager_Ref.UpdateCurrentlyVisible(self)
	#else:
		#push_error(self.name + " Has no UI_Manager_Ref assigned. Please chexck Inspector.")
