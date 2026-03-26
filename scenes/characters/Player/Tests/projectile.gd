extends RigidBody3D

@export var forceToApply: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_force(Vector3.FORWARD * forceToApply)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	pass
