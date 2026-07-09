extends Control

signal resume
signal open_settings

@onready var resume_button: Button = $Panel/ResumeButton
@onready var version_label: Label = $Panel/VersionLabel

func _ready() -> void:
	version_label.text = "v" + str(ProjectSettings.get_setting("application/config/version"))

func _on_visibility_changed() -> void:
	if visible:
		resume_button.grab_focus()

func _on_resume_button_pressed() -> void:
	resume.emit()

func _on_settings_button_pressed() -> void:
	open_settings.emit()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
