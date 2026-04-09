extends Node

@export var outlineMaterial: ShaderMaterial = preload("uid://d1hbc5mvwhs5")

# Called when the node enters the scene tree for the first time.
func getOutlineMaterial()->ShaderMaterial:
	return outlineMaterial
