class_name Spectator
extends RigidBody3D

const MOVE_MULT: float = 750.01
const LINEAR_DAMP: float = 12.4
const MIN: float = 0.1
var normal_speed: int = 10
var run_speed: float = 15
var move_speed: float
var run_input: bool

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	gravity_scale = 0
