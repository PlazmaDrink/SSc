class_name data_to_save
extends Resource

# All vars have to be @export
const PRELOAD = preload("uid://csqeytjnduddh")

@export var position:Vector3
@export var scene_path:String
@export var parent_path:String
@export var index: int
@export var isGlobal:bool

func save_properties(root:Node, _custom:Node = null, inIsGlobal = false)->void:
	if !isGlobal:
		self.position = root.position
		self.scene_path = root.scene_file_path
		self.parent_path = root.get_parent().get_path()
		self.index = root.get_index()
		self.isGlobal = inIsGlobal

func load_properties(root:Node, _custom:Node = null)->void:
	root.position = position

func get_preload()->Resource:
	return PRELOAD
