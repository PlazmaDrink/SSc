extends Node

@export var outlineMaterial: ShaderMaterial

signal OnRayTraceEnter(shader)
# Called when the node enters the scene tree for the first time.
func onRayTraceEnter()->void:
	OnRayTraceEnter.emit(outlineMaterial)
