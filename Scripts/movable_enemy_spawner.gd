extends Node3D

@onready var spawn_timer: Timer = $SpawnTimer
const SPAWN_X_AND_Z_RANGE: int = 15
const SPEED_RANGE: float = 7.5
const SPAWN_TIME: float = 0.15
const MOVABLE_ENEMY_SCENE = preload("res://Scenes/movable_enemy.tscn")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	spawn_timer.wait_time = SPAWN_TIME
	spawn_timer.autostart = true
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	var new_movable_enemy = MOVABLE_ENEMY_SCENE.instantiate()
	new_movable_enemy.position = global_position + Vector3(randf_range(-SPAWN_X_AND_Z_RANGE, SPAWN_X_AND_Z_RANGE), 0, randf_range(-SPAWN_X_AND_Z_RANGE, SPAWN_X_AND_Z_RANGE))
	owner.add_child(new_movable_enemy)
	new_movable_enemy.linear_velocity = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized() * SPEED_RANGE
