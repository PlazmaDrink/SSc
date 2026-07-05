class_name Item
extends Resource

enum ItemType{
	Food,
	Stationery,
	Parts,
}
enum AssetType{
	Small,
	Medium,
	Large
}
enum ItemRarity {
	COMMON,
	UNCOMMON, 
	RARE,
	EPIC,
	LEGENDARY
}
@export var id: String = ""
@export var name: String = ""
@export var description: String = ""
@export var icon: Texture2D

@export var stackable: bool = true
@export var max_stack: int = 99

@export var item_type: ItemType = ItemType.Parts
@export var rarity: ItemRarity = ItemRarity.COMMON
@export var value: int = 0

@export var assetsRef:Dictionary = {AssetType.Small: "", AssetType.Medium:"", AssetType.Large:""}

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"description": description,
		"stackable": stackable,
		"max_stack": max_stack,
		"item_type": item_type,
		"rarity": rarity,
		"value": value
	}

func from_dict(data: Dictionary) -> void:
	id = data.get("id", "")
	name = data.get("name", "")
	description = data.get("description", "")
	stackable = data.get("stackable", true)
	max_stack = data.get("max_stack", 99)
	item_type = data.get("item_type", ItemType.Parts)
	rarity = data.get("rarity", ItemRarity.COMMON)
	value = data.get("value", 0)

func can_stack_with(other_item: Item) -> bool:
	return stackable && other_item.stackable && id == other_item.id

func getAssetByQuantity(amount: int)->String:
	var assetToReturn:AssetType
	if amount <3:
		assetToReturn = AssetType.Small
	elif amount >2 and amount<10:
		assetToReturn = AssetType.Medium
	else:
		assetToReturn = AssetType.Large
	return assetsRef.get(assetToReturn)
