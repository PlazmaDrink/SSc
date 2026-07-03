class_name StorageUnit
extends Resource

enum ItemTypes{
	Food,
	Stationery,
	Parts,
}

@export var myStorageType:ItemTypes
@export var maxCapacity:int
@export var currentCapacity:int
