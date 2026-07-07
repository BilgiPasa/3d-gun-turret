class_name SpectatorAndCamera
extends Node3D

# Camera Rotation
var mouse_sensitivity: int = 100
var x_rot_deg: float = 0 # x rotation degrees
var y_rot_deg: float = 0 # y rotation degrees

# Camera Rotation Multipliers
const NORMAL_CAM_ROT_MULT: int = 1
const ZOOMED_CAM_ROT_MULT: float = 0.5
var current_cam_rot_mult: float

# Camera FOV
const NORMAL_FOV: int = 90
const SPRINT_FOV_CHANGE: int = 10
var sprint_fov: int
var zoom_fov: float
var zoom_sprint_fov: float

# Camera Zoom
var zooming_speed: int = 12
var zoom_input: bool

# @export Variables
@onready var spectator: Spectator = $Spectator
@onready var camera_holder: Node3D = $CameraHolder
@onready var camera: Camera3D = $CameraHolder/Camera3D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	current_cam_rot_mult = NORMAL_CAM_ROT_MULT
	camera.fov = NORMAL_FOV

# * Get camera rotation input
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		y_rot_deg -= event.relative.x * mouse_sensitivity * current_cam_rot_mult * 0.001
		x_rot_deg -= event.relative.y * mouse_sensitivity * current_cam_rot_mult * 0.001
		x_rot_deg = clamp(x_rot_deg, -90, 90)

func _process(delta: float) -> void:
	camera_position_and_rotation()
	fov_change(delta)

func camera_position_and_rotation() -> void:
	camera_holder.global_position = spectator.global_position # Move camera holder to camera position
	camera_holder.rotation_degrees = Vector3(x_rot_deg, y_rot_deg, 0) # Rotate camera holder
	spectator.y_rot_deg = y_rot_deg # Assign rotation degrees for player

func fov_change(process_delta: float) -> void:
	zoom_input = Input.is_action_pressed("camera_zoom") # Get camera_zoom input

	if !zoom_input:
		current_cam_rot_mult = NORMAL_CAM_ROT_MULT

		if !(spectator.current_state == spectator.States.RUNNING):
			if camera.fov > NORMAL_FOV - 0.01 && camera.fov < NORMAL_FOV + 0.01:
				camera.fov = NORMAL_FOV
			else:
				camera.fov = lerpf(camera.fov, NORMAL_FOV, zooming_speed * process_delta)
		else:
			sprint_fov = NORMAL_FOV + SPRINT_FOV_CHANGE

			if camera.fov > sprint_fov - 0.01:
				camera.fov = sprint_fov
			else:
				camera.fov = lerpf(camera.fov, sprint_fov, zooming_speed * process_delta)
	else:
		current_cam_rot_mult = ZOOMED_CAM_ROT_MULT

		if !(spectator.current_state == spectator.States.RUNNING):
			zoom_fov = NORMAL_FOV / 5.0

			if camera.fov < zoom_fov + 0.01:
				camera.fov = zoom_fov
			else:
				camera.fov = lerpf(camera.fov, zoom_fov, zooming_speed * process_delta)
		else:
			zoom_sprint_fov = (NORMAL_FOV + SPRINT_FOV_CHANGE) / 5.0

			if camera.fov > zoom_sprint_fov - 0.01 && camera.fov < zoom_sprint_fov + 0.01:
				camera.fov = zoom_sprint_fov
			else:
				camera.fov = lerpf(camera.fov, zoom_sprint_fov, zooming_speed * process_delta)

func get_player_speed() -> float:
	return spectator.get_speed()
