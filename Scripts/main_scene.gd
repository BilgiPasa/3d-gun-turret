extends Node3D

@onready var movable_enemy_spawner: Node3D = $MovableEnemySpawner
@onready var gun_turret: GunTurret = $GunTurret
@onready var static_enemy_spawner: Node3D = $StaticEnemySpawner
@onready var pause_menu: Control = $CanvasLayer/PauseMenu
@onready var settings_menu: Control = $CanvasLayer/SettingsMenu
var enemy_hit_ground_count: int = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
	pause_menu.hide()
	settings_menu.process_mode = Node.PROCESS_MODE_DISABLED
	settings_menu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"): # If "esc" key pressed
		if !get_tree().paused:
			pause()
		else:
			if !settings_menu.visible:
				resume()
			else:
				close_settings()

func pause() -> void:
	get_tree().paused = true
	pause_menu.process_mode = Node.PROCESS_MODE_INHERIT
	pause_menu.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func resume() -> void:
	get_tree().paused = false
	pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
	pause_menu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func open_settings() -> void:
	pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
	settings_menu.process_mode = Node.PROCESS_MODE_INHERIT
	settings_menu.show()
	pause_menu.hide()

func close_settings() -> void:
	settings_menu.process_mode = Node.PROCESS_MODE_DISABLED
	pause_menu.process_mode = Node.PROCESS_MODE_INHERIT
	pause_menu.show()
	settings_menu.hide()

func _on_gun_turret_update_hit_lbl(hit_count: int) -> void:
	pause_menu.enemy_hit_gt_count_label.text = "%d enemies have hit to the gun turret" % hit_count

func _on_ground_area_body_entered(body: Node3D) -> void:
	enemy_hit_ground_count += 1
	pause_menu.enemy_hit_ground_count_label.text = "%d enemies have hit to the ground" % enemy_hit_ground_count
	body.queue_free.call_deferred()

func _on_pause_menu_resume() -> void:
	resume()

func _on_pause_menu_open_settings() -> void:
	open_settings()

func _on_settings_menu_turn_on_mes() -> void: # mes = movable enemy spawner
	movable_enemy_spawner.process_mode = Node.PROCESS_MODE_PAUSABLE

func _on_settings_menu_turn_off_mes() -> void: # mes = movable enemy spawner
	movable_enemy_spawner.process_mode = Node.PROCESS_MODE_DISABLED

func _on_settings_menu_turn_on_gt() -> void: # gt = gun turret
	gun_turret.process_mode = Node.PROCESS_MODE_PAUSABLE
	gun_turret.show()

func _on_settings_menu_turn_off_gt() -> void: # gt = gun turret
	gun_turret.process_mode = Node.PROCESS_MODE_DISABLED
	gun_turret.hide()

func _on_settings_menu_turn_on_ses() -> void: # ses = static enemy spawner
	static_enemy_spawner.process_mode = Node.PROCESS_MODE_PAUSABLE

func _on_settings_menu_turn_off_ses() -> void: # ses = static enemy spawner
	static_enemy_spawner.process_mode = Node.PROCESS_MODE_DISABLED

func _on_settings_menu_go_back() -> void:
	close_settings()
