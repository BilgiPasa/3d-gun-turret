class_name GunTurret
extends StaticBody3D

# Shoot Bullet Variables
const SHOOT_TIMER_WAIT_TIME: float = 0.05
var can_shoot: bool = true

# Gun Turret Labels Variable
var show_labels: bool = true

# @onready Variables
@onready var can_shoot_timer: Timer = $CanShootTimer
@onready var gun_turret_labels: Node3D = $GunTurretLabels

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	can_shoot_timer.wait_time = SHOOT_TIMER_WAIT_TIME

	if show_labels:
		gun_turret_labels.show()
	else:
		gun_turret_labels.hide()

func _on_can_shoot_timer_timeout() -> void:
	can_shoot_timer.stop()
	can_shoot = true
