class_name Spectator
extends RigidBody3D

# Movement
const MOVE_MULT: float = 750.01
const LINEAR_DAMP: float = 12.4
const MIN: float = 0.1
var normal_speed: int = 10
var run_speed: float = 20
var move_speed: float
var run_input: bool
var move_vector: Vector3
var move_vector_relative_to_world: Vector3

# Player States
enum States
{
	IDLE = 0,
	WALKING = 1,
	RUNNING = 2,
}

# Player State Variable
var current_state: States

# Player Rotation
var y_rot_deg: float # This variable is assigned by the player_and_camera script

# @onready Variable
@onready var camera_position: Node3D

func _ready() -> void:
	gravity_scale = 0
	linear_damp = LINEAR_DAMP
	mass = 75
	can_sleep = false
	lock_rotation = true

# * Get inputs
func _process(_delta: float) -> void:
	run_input = Input.is_action_pressed("run")

	# Forward is -Z, Backwards is Z, Right is X, Left is -X, Up is Y, Down is -Y
	move_vector = Vector3(Input.get_axis("move_left", "move_right"), Input.get_axis("move_down", "move_up"), Input.get_axis("move_forward", "move_back")).normalized()

# * Handle other things
func _physics_process(delta: float) -> void:
	rotation_degrees.y = y_rot_deg
	movement(delta)
	current_state = player_state_machine(current_state)
	move_speed_control()

func movement(physics_process_delta: float) -> void:
	move_vector_relative_to_world = rotate_vector_around_y_axis(move_vector, deg_to_rad(y_rot_deg))
	apply_force(move_speed * MOVE_MULT * physics_process_delta * mass * move_vector_relative_to_world)

func rotate_vector_around_y_axis(vector: Vector3, radians: float) -> Vector3:
	return Vector3(vector.x * cos(radians) + vector.z * sin(radians), vector.y, -vector.x * sin(radians) + vector.z * cos(radians))

func player_state_machine(state: States) -> States:
	if state == States.IDLE:
		if get_speed() > MIN:
			return States.WALKING
		else:
			return States.IDLE
	elif state == States.WALKING:
		if get_speed() > MIN:
			if run_input:
				return States.RUNNING
			else:
				return States.WALKING
		else:
			return States.IDLE
	elif state == States.RUNNING:
		if get_speed() > MIN:
			if run_input:
				return States.RUNNING
			else:
				return States.WALKING
		else:
			return States.IDLE
	else:
		return state

func get_speed() -> float:
	return sqrt(pow(linear_velocity.x, 2) + pow(linear_velocity.y, 2) + pow(linear_velocity.z, 2))

func move_speed_control() -> void:
	match current_state:
		States.RUNNING:
			move_speed = run_speed
		_:
			move_speed = normal_speed

	if abs(linear_velocity.z) <= MIN:
		linear_velocity.z = 0

	if abs(linear_velocity.x) <= MIN:
		linear_velocity.x = 0

	if abs(linear_velocity.y) <= MIN:
		linear_velocity.y = 0
