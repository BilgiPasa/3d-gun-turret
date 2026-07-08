class_name StaticEnemy
extends RigidBody3D

@onready var retarget_timer: Timer = $RetargetTimer
var targeted: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	continuous_cd = true
	contact_monitor = true
	max_contacts_reported = 1
	freeze = true
	freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	retarget_timer.wait_time = 0.2

func _on_body_entered(body: Node) -> void:
	body.queue_free.call_deferred()
	queue_free.call_deferred()

func _on_retarget_timer_timeout() -> void:
	retarget_timer.stop()
	targeted = false
