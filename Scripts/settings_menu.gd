extends Control

signal turn_on_mes # Turn On Movable Enemy Spawner
signal turn_off_mes # Turn On Movable Enemy Spawner
signal turn_on_gt # Turn On Gun Turret
signal turn_off_gt # Turn Off Gun Turret
signal turn_on_ses # Turn On Static Enemy Spawner
signal turn_off_ses # Turn On Static Enemy Spawner
signal go_back

@onready var mes_on_off_button: Button = $Panel/MESOnOffButton # Movable Enemy Spawner On Off Button
@onready var gt_on_off_button: Button = $Panel/GTOnOffButton # Gun Turret On Off Button
@onready var ses_on_off_button: Button = $Panel/SESOnOffButton # Static Enemy Spawner On Off Button
@onready var go_back_button: Button = $Panel/GoBackButton
var mes_on: bool = true # Movable Enemy Spawner On
var gt_on: bool = true # Gun Turret On
var ses_on: bool = true # Static Enemy Spawner On

func _on_visibility_changed() -> void:
	if visible:
		go_back_button.grab_focus()

# On Movable Enemy Spawner On Off Button Pressed
func _on_mes_on_off_button_pressed() -> void:
	if mes_on:
		mes_on = false
		turn_off_mes.emit()
		mes_on_off_button.text = "Enable Movable\nEnemy Spawning"
	else:
		mes_on = true
		turn_on_mes.emit()
		mes_on_off_button.text = "Disable Movable\nEnemy Spawning"

# On Gun Turret On Off Button Pressed
func _on_gt_on_off_button_pressed() -> void:
	if gt_on:
		gt_on = false
		turn_off_gt.emit()
		gt_on_off_button.text = "Enable\nGun Turret"
	else:
		gt_on = true
		turn_on_gt.emit()
		gt_on_off_button.text = "Disable\nGun Turret"

# On Static Enemy Spawner On Off Button Pressed
func _on_ses_on_off_button_pressed() -> void:
	if ses_on:
		ses_on = false
		turn_off_ses.emit()
		ses_on_off_button.text = "Enable Static\nEnemy Spawning"
	else:
		ses_on = true
		turn_on_ses.emit()
		ses_on_off_button.text = "Disable Static\nEnemy Spawning"

func _on_go_back_button_pressed() -> void:
	go_back.emit()
