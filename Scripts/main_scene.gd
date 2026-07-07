extends Node3D

@onready var gun_turret: GunTurret = $GunTurret
@onready var pause_menu: Control = $CanvasLayer/PauseMenu
@onready var settings_menu: Control = $CanvasLayer/SettingsMenu

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
	pause_menu.hide()
	settings_menu.process_mode = Node.PROCESS_MODE_DISABLED
	settings_menu.hide()

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

func resume() -> void:
	get_tree().paused = false
	pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
	pause_menu.hide()

func open_settings() -> void:
	settings_menu.process_mode = Node.PROCESS_MODE_INHERIT
	settings_menu.show()

func close_settings() -> void:
	settings_menu.process_mode = Node.PROCESS_MODE_DISABLED
	settings_menu.hide()
