class_name StoreItem
extends Resource

@export var id: String = ""
@export var name: String = ""
@export var description: String = ""
@export var icon: Texture2D
@export var value: int = 0
@export var assetsRef:String

func load_assets()->void:
	AssetsManager.request_load(assetsRef)

func getAsset()->PackedScene:
	var scene:PackedScene = AssetsManager.get_asset(assetsRef)
	return scene
