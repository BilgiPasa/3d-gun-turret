class_name GunTurret
extends StaticBody3D

# Shoot Bullet Variables
const BULLET_DEFAULT_LIN_VEL_X_AND_Z: float = 150
const BULLET_MIN_REACH_TIME: float = 0.15
const SHOOT_TIMER_WAIT_TIME: float = 0.05
const BULLET_SCENE = preload("res://Scenes/bullet.tscn")
var gravity_amount: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var t: float
var can_shoot: bool = true
var target_relative_position: Vector3
var shoot_vector: Vector3
var closest_target: Node3D
var targets: Array[Node3D]

# Gun Turret Labels Variable
var show_labels: bool = true

# @onready Variables
@onready var gun_mesh_holder: Node3D = $GunMeshHolder
@onready var can_shoot_timer: Timer = $CanShootTimer
@onready var target_find_area: Area3D = $TargetFindArea
@onready var gun_turret_labels: Node3D = $GunTurretLabels

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	can_shoot_timer.wait_time = SHOOT_TIMER_WAIT_TIME

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

	var new_bullet = BULLET_SCENE.instantiate() # Make a new bullet
	target_relative_position = Vector3(target.global_position.x - gun_mesh_holder.global_position.x, target.global_position.y - gun_mesh_holder.global_position.y, target.global_position.z - gun_mesh_holder.global_position.z) # Find the position of the target relative to the gun

	if target is MovableEnemy:
		# Calculate reach time and X speed based on enemy speed and default X speed
		if target_relative_position.x >= 0: # If the enemy is at the right of the turret
			if target.linear_velocity.x >= 0: # If the enemy is moving to right
				t = abs(target_relative_position.x) / (BULLET_DEFAULT_LIN_VEL_X_AND_Z - target.linear_velocity.x)
			else: # If the enemy is moving to left
				t = abs(target_relative_position.x) / (BULLET_DEFAULT_LIN_VEL_X_AND_Z + target.linear_velocity.x)

			if t >= BULLET_MIN_REACH_TIME:
				shoot_vector.x = BULLET_DEFAULT_LIN_VEL_X_AND_Z
				shoot_vector.z = (target_relative_position.z / t) + target.linear_velocity.z
			else:
				if target_relative_position.z >= 0: # If the enemy is at the back of the turret
					if target.linear_velocity.z >= 0: # If the enemy is moving to back
						t = abs(target_relative_position.z) / (BULLET_DEFAULT_LIN_VEL_X_AND_Z - target.linear_velocity.z)
					else: # If the enemy is moving to front
						t = abs(target_relative_position.z) / (BULLET_DEFAULT_LIN_VEL_X_AND_Z + target.linear_velocity.z)

					if t >= BULLET_MIN_REACH_TIME:
						shoot_vector.x = (target_relative_position.x / t) + target.linear_velocity.x
						shoot_vector.z = BULLET_DEFAULT_LIN_VEL_X_AND_Z
					else:
						t = BULLET_MIN_REACH_TIME
						shoot_vector.x = (target_relative_position.x / t) + target.linear_velocity.x
						shoot_vector.z = (target_relative_position.z / t) + target.linear_velocity.z
				else: # If the enemy is at the front of the turret
					if target.linear_velocity.z >= 0: # If the enemy is moving to back
						t = abs(target_relative_position.z) / (BULLET_DEFAULT_LIN_VEL_X_AND_Z - target.linear_velocity.z)
					else: # If the enemy is moving to front
						t = abs(target_relative_position.z) / (BULLET_DEFAULT_LIN_VEL_X_AND_Z + target.linear_velocity.z)

					if t >= BULLET_MIN_REACH_TIME:
						shoot_vector.x = (target_relative_position.x / t) + target.linear_velocity.x
						shoot_vector.z = -BULLET_DEFAULT_LIN_VEL_X_AND_Z
					else:
						t = BULLET_MIN_REACH_TIME
						shoot_vector.x = (target_relative_position.x / t) + target.linear_velocity.x
						shoot_vector.z = (target_relative_position.z / t) + target.linear_velocity.z
		else: # If the enemy is at the left of the turret
			if target.linear_velocity.x >= 0: # If the enemy is moving to right
				t = abs(target_relative_position.x) / (BULLET_DEFAULT_LIN_VEL_X_AND_Z - target.linear_velocity.x)
			else: # If the enemy is moving to left
				t = abs(target_relative_position.x) / (BULLET_DEFAULT_LIN_VEL_X_AND_Z + target.linear_velocity.x)

			if t >= BULLET_MIN_REACH_TIME:
				shoot_vector.x = -BULLET_DEFAULT_LIN_VEL_X_AND_Z
				shoot_vector.z = (target_relative_position.z / t) + target.linear_velocity.z
			else:
				if target_relative_position.z >= 0: # If the enemy is at the back of the turret
					if target.linear_velocity.z >= 0: # If the enemy is moving to back
						t = abs(target_relative_position.z) / (BULLET_DEFAULT_LIN_VEL_X_AND_Z - target.linear_velocity.z)
					else: # If the enemy is moving to front
						t = abs(target_relative_position.z) / (BULLET_DEFAULT_LIN_VEL_X_AND_Z + target.linear_velocity.z)

					if t >= BULLET_MIN_REACH_TIME:
						shoot_vector.x = (target_relative_position.x / t) + target.linear_velocity.x
						shoot_vector.z = BULLET_DEFAULT_LIN_VEL_X_AND_Z
					else:
						t = BULLET_MIN_REACH_TIME
						shoot_vector.x = (target_relative_position.x / t) + target.linear_velocity.x
						shoot_vector.z = (target_relative_position.z / t) + target.linear_velocity.z
				else: # If the enemy is at the front of the turret
					if target.linear_velocity.z >= 0: # If the enemy is moving to back
						t = abs(target_relative_position.z) / (BULLET_DEFAULT_LIN_VEL_X_AND_Z - target.linear_velocity.z)
					else: # If the enemy is moving to front
						t = abs(target_relative_position.z) / (BULLET_DEFAULT_LIN_VEL_X_AND_Z + target.linear_velocity.z)

					if t >= BULLET_MIN_REACH_TIME:
						shoot_vector.x = (target_relative_position.x / t) + target.linear_velocity.x
						shoot_vector.z = -BULLET_DEFAULT_LIN_VEL_X_AND_Z
					else:
						t = BULLET_MIN_REACH_TIME
						shoot_vector.x = (target_relative_position.x / t) + target.linear_velocity.x
						shoot_vector.z = (target_relative_position.z / t) + target.linear_velocity.z

		# There is no gravity calculation here because the bullet and the movable enemy have the same gravity
		shoot_vector.y = (target_relative_position.y / t) + target.linear_velocity.y # Calculate Y speed
	else:
		t = abs(target_relative_position.x) / BULLET_DEFAULT_LIN_VEL_X_AND_Z # Calculate reach time based on default X and Z speed

		if t >= BULLET_MIN_REACH_TIME:
			# Assign X speed
			if target_relative_position.x >= 0:
				shoot_vector.x = BULLET_DEFAULT_LIN_VEL_X_AND_Z
			else:
				shoot_vector.x = -BULLET_DEFAULT_LIN_VEL_X_AND_Z

			shoot_vector.z = target_relative_position.z / t
		else: # If reach time is too small when calculated for X
			t = abs(target_relative_position.z) / BULLET_DEFAULT_LIN_VEL_X_AND_Z # Calculate reach time based on default X and Z speed

			if t >= BULLET_MIN_REACH_TIME:
				# Assign Z speed
				if target_relative_position.z >= 0:
					shoot_vector.z = BULLET_DEFAULT_LIN_VEL_X_AND_Z
				else:
					shoot_vector.z = -BULLET_DEFAULT_LIN_VEL_X_AND_Z

				shoot_vector.x = target_relative_position.x / t
			else: # If reach time is too small when calculated for X and Z
				t = BULLET_MIN_REACH_TIME # Set the reach time
				shoot_vector.x = target_relative_position.x / t # Calculate X speed
				shoot_vector.z = target_relative_position.z / t # Calculate Z speed

		# At the line below, I used (physics_delta * 4) to hit the target better because if I don't add it, it might miss the target by a small distance.
		shoot_vector.y = (target_relative_position.y / t) + (gravity_amount * (t + (physics_delta * 4)) / 2) # Calculate Y speed

	gun_mesh_holder.look_at(shoot_vector) # Gun sprite looks at the target
	new_bullet.position = gun_mesh_holder.global_position # Initialize the position of the bullet
	owner.add_child(new_bullet) # Add the bullet to the scene
	new_bullet.linear_velocity = shoot_vector # Add speed to the bullet

func give_closest_target() -> Node3D:
	closest_target = null
	targets = target_find_area.get_overlapping_bodies()

	if len(targets) > 0:
		closest_target = targets[0]

		for i in range(1, len(targets)):
			if !targets[i].targeted && how_far_from_gun_turret_ground(closest_target.global_position) > how_far_from_gun_turret_ground(targets[i].global_position):
				closest_target = targets[i]

	closest_target.targeted = true
	closest_target.retarget_timer.start()
	return closest_target

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
	print("Enemy has hit to the gun turret")
	body.queue_free.call_deferred()
