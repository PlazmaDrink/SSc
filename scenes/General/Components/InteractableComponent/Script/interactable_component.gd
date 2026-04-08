extends Node

@export var outlineShader:Shader

signal OnRayTraceEnter(shader)
signal OnRayTraceExit
# Called when the node enters the scene tree for the first time.
func onRayTraceEnter()->void:
	OnRayTraceEnter.emit(outlineShader)

func onRayTraceExit()->void:
	OnRayTraceExit.emit
