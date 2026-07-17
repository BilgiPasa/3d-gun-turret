class_name GunTurret
extends StaticBody3D

signal update_hit_lbl(hit_count: int)

# Shoot Bullet Variables
const BULLET_SCENE = preload("res://Scenes/bullet.tscn")
var bullet_reach_time: float = Globals.GT_BULLET_REACH_TIME
var gravity_amount: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var can_shoot: bool = true
var target_relative_position: Vector3
var shoot_vector: Vector3
var closest_target: Node3D
var targets: Array[Node3D]

# @onready Variables
@onready var gun_mesh_holder: Node3D = $GunMeshHolder
@onready var can_shoot_timer: Timer = $CanShootTimer
@onready var target_find_area: Area3D = $TargetFindArea
@onready var gun_turret_labels: Node3D = $GunTurretLabels

# Other Variables
var enemy_hit_gt_count: int = 0
var show_labels: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	can_shoot_timer.wait_time = Globals.GT_CAN_SHOOT_TIMER_WAIT_TIME

	if show_labels:
		gun_turret_labels.show()
	else:
		gun_turret_labels.hide()

func _physics_process(delta: float) -> void:
	attack_closest_target(delta)

func attack_closest_target(physics_delta: float) -> void:
	if target_find_area.has_overlapping_bodies() && can_shoot:
		can_shoot = false
		shoot_bullet_to(give_closest_target(), physics_delta)
		can_shoot_timer.start()

func shoot_bullet_to(target: Node3D, physics_delta: float) -> void:
	if target == null:
		return

	# Make a new bullet
	var new_bullet = BULLET_SCENE.instantiate()

	# Find the position of the target relative to the gun
	target_relative_position = Vector3(target.global_position.x - gun_mesh_holder.global_position.x, target.global_position.y - gun_mesh_holder.global_position.y, target.global_position.z - gun_mesh_holder.global_position.z)

	if target is MovableEnemy:
		# Calculate X speed
		shoot_vector.x = (target_relative_position.x / bullet_reach_time) + target.linear_velocity.x

		# Calculate Y speed
		# There is no gravity calculation here because the bullet and the movable enemy have the same gravity.
		shoot_vector.y = (target_relative_position.y / bullet_reach_time) + target.linear_velocity.y

		# Calculate Z speed
		shoot_vector.z = (target_relative_position.z / bullet_reach_time) + target.linear_velocity.z
	else:
		# Calculate X speed
		shoot_vector.x = target_relative_position.x / bullet_reach_time

		# Calculate Y speed
		# At the line below, I used (physics_delta * 5) to hit the target better because if I don't add it, it might miss the target by a small distance.
		shoot_vector.y = (target_relative_position.y / bullet_reach_time) - (gravity_amount * (bullet_reach_time + (physics_delta * 5)) / 2)

		# Calculate Z speed
		shoot_vector.z = (target_relative_position.z / bullet_reach_time)

	gun_mesh_holder.look_at(shoot_vector) # Make the gun mesh look at the target
	new_bullet.position = gun_mesh_holder.global_position # Initialize the position of the bullet
	owner.add_child(new_bullet) # Add the bullet to the scene
	new_bullet.linear_velocity = shoot_vector # Add velocity to the bullet

func give_closest_target() -> Node3D:
	closest_target = null
	targets = target_find_area.get_overlapping_bodies() # Get the enemies inside of the target find area

	if len(targets) > 0: # If there are enemies inside of the target find area
		closest_target = targets[0] # Starting from the first node

		# Compare all of the nodes
		for i in range(1, len(targets)):
			if !targets[i].targeted && how_far_from_gun_turret_ground(closest_target.global_position) > how_far_from_gun_turret_ground(targets[i].global_position):
				closest_target = targets[i]

	if !closest_target.targeted: # If the selected target is not targeted
		closest_target.targeted = true # Make it targeted
		closest_target.retarget_timer.start() # Start its retarget timer
		return closest_target # return the selected target
	else:
		return null

# Calculate how far is the target from the gun turret ground
func how_far_from_gun_turret_ground(target_global_position: Vector3) -> float:
	return abs(target_global_position.y - global_position.y)

# Calculate how far is the target from the gun
func how_far_from_gun(target_global_position: Vector3) -> float:
	target_relative_position = Vector3(target_global_position.x - gun_mesh_holder.global_position.x, target_global_position.y - gun_mesh_holder.global_position.y, target_global_position.z - gun_mesh_holder.global_position.z)
	return sqrt(pow(target_relative_position.x, 2) + pow(target_relative_position.y, 2) + pow(target_relative_position.z, 2))

func _on_can_shoot_timer_timeout() -> void:
	can_shoot_timer.stop()
	can_shoot = true

func _on_gt_area_body_entered(body: Node3D) -> void:
	enemy_hit_gt_count += 1
	update_hit_lbl.emit(enemy_hit_gt_count)
	body.queue_free.call_deferred()
