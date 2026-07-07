extends RigidBody3D

@onready var camera_holder: Node3D = $CameraHolder
@onready var camera: Camera3D = $CameraHolder/Camera3D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	gravity_scale = 0
