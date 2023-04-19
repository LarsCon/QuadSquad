extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	player.set_animation("Jump Start")

func physics_process(_delta):
	if not player.dashing:
		if Input.is_action_pressed("dash") and player.can_dash:
			SM.set_state("Dashing")
			return
		if Input.is_action_pressed("shoot") and not player.shooting:
			player.shoot()
		if player.shooting:
			if Input.is_action_pressed("up"):
				if (abs(player.velocity.y) < player.apex_velocity_threshold):
					player.set_animation("Jump Apex Shoot Upward")
				elif (player.velocity.y > 0):
					player.set_animation("Jump Fall Shoot Upward")
				else:
					player.set_animation("Jump Start Shoot Upward")
			elif Input.is_action_pressed("down"):
				if (abs(player.velocity.y) < player.apex_velocity_threshold):
					player.set_animation("Jump Apex Shoot Downward")
				elif (player.velocity.y > 0):
					player.set_animation("Jump Fall Shoot Downward")
				else:
					player.set_animation("Jump Start Shoot Downward")
			else:
				if (abs(player.velocity.y) < player.apex_velocity_threshold):
					player.set_animation("Jump Apex Shoot Forward")
				elif (player.velocity.y > 0):
					player.set_animation("Jump Fall Shoot Forward")
				else:
					player.set_animation("Jump Start Shoot Forward")
		else:
			if (abs(player.velocity.y) < player.apex_velocity_threshold):
				player.in_air_value = 1
				player.set_animation("Jump Apex")
			elif (player.velocity.y > 0):
				player.in_air_value = 2
				player.set_animation("Jump Fall")
			else:
				player.in_air_value = 0
				player.set_animation("Jump Start")
		var input_vector = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),0.0)
		player.velocity += player.move_speed * input_vector + player.gravity
		player.move_and_slide(player.velocity, Vector2.UP)
		player.set_direction(sign(input_vector.x))
		if player.is_on_floor() and player.velocity.dot(Vector2.UP) < 0:
			player.velocity.y = 0
			if input_vector.x > 0 or input_vector.x < 0:
				SM.set_state("Moving")
			else:
				player.velocity = Vector2.ZERO
				SM.set_state("Idle")
		if player.is_on_ceiling():
			player.velocity.y = 0
