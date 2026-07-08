extends Node3D

@onready var spawn_timer: Timer = $SpawnTimer
const SPAWN_RANGE: int = 15
const SPAWN_TIME: float = 0.15
const STATIC_ENEMY_SCENE = preload("res://Scenes/static_enemy.tscn")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	spawn_timer.wait_time = SPAWN_TIME
	spawn_timer.autostart = true
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	var new_static_enemy = STATIC_ENEMY_SCENE.instantiate()
	new_static_enemy.position = global_position + Vector3(randf_range(-SPAWN_RANGE, SPAWN_RANGE), randf_range(-SPAWN_RANGE, SPAWN_RANGE), randf_range(-SPAWN_RANGE, SPAWN_RANGE))
	owner.add_child(new_static_enemy)
