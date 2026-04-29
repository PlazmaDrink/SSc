extends Node3D

@export var projectileScene: PackedScene

@onready var player_input: Node3D = $"../PlayerInput"
@onready var projectile_spawn_path: Node3D = $ProjectileSpawnPath
@onready var marker_3d: Marker3D = $Marker3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#player_input.fire_input.connect(_on_fire_input)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_fire_input() -> void:
	var projectile = projectileScene.instantiate() as RigidBody3D
	projectile.transform = marker_3d.transform
	projectile_spawn_path.add_child(projectile, true)
