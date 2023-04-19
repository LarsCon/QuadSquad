extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	player.set_animation("Run")

func physics_process(_delta):
	player.can_dash = true
	if not player.dashing:
		if Input.is_action_pressed("dash") and player.can_dash:
			SM.set_state("Dashing")
			return
		if Input.is_action_pressed("shoot") and not player.shooting:
			player.shoot()
		if player.shooting:
			if Input.is_action_pressed("up"):
				player.set_animation("Run Shoot Upward")
			elif Input.is_action_pressed("down"):
				player.set_animation("Run Shoot Downward")
			else:
				player.set_animation("Run Shoot Forward")
		else:
			player.set_animation("Run")
		if not player.is_on_floor() and not player.detects_ground:
			SM.set_state("In_Air")
		if Input.is_action_pressed("jump"):
			player.jump()
			SM.set_state("In_Air")
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			var input_vector = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),0.0)
			player.set_direction(sign(input_vector.x))
			player.velocity += player.move_speed * input_vector
			player.move_and_slide(player.velocity, Vector2.UP)
		else:
			player.velocity = Vector2.ZERO
			SM.set_state("Idle")

