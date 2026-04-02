class_name DataToSave
extends Resource

# In order to save/load data:
# Parent has to have implemented 3 functions:
# func on_save_game(saved_data:Array[DataToSave]):
# func on_before_load():
# func on_load_game(data:DataToSave):
# If some object specific data required - create new script that inherits from DataToSave
# All vars have to be @export

@export var position:Vector3
@export var scene_path:String
@export var parent_path:String
@export var index: int
