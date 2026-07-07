extends Control
class_name CustomControl

@export_category("Visibility Parents")
@export var VisibleParent:Control
@export var InvisibleParent:Control
# Called when the node enters the scene tree for the first time.

func reparentOnVisibilityChange()->void:
	if visible and VisibleParent:
		self.reparent(VisibleParent)
	else:
		if InvisibleParent:
			self.reparent(InvisibleParent)
