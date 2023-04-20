extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	if player.health > 0:
		player.set_animation("Jump")

func physics_process(_delta):
	var input_vector = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), 0.0)
	player.velocity += player.move_speed * input_vector + player.gravity
	if player.shoot_launch:
		player.velocity = Vector2.ZERO
		player.velocity += Vector2.UP.rotated(player.WJ.rotation - PI/2) * player.reverse_boost
		player.added_x_velocity = abs((Vector2.UP.rotated(player.WJ.rotation - PI/2) * player.reverse_boost).x)
		player.shoot_launch = false
	player.move_and_slide(player.velocity, Vector2.UP)
	player.set_direction(sign(input_vector.x))
	if player.is_on_floor() and player.velocity.dot(Vector2.UP) < 0:
		player.velocity.y = 0
		if input_vector.x > 0 or input_vector.x < 0:
			SM.set_state("Moving")
			player.added_x_velocity = 0.0
			player.can_shoot = true
		else:
			player.velocity = Vector2.ZERO
			SM.set_state("Idle")
			player.added_x_velocity = 0.0
			player.can_shoot = true
	if player.is_on_ceiling():
		player.velocity.y = 0
	if Input.is_action_just_pressed("shoot") and player.can_shoot and not player.cooldown:
		player.can_shoot = false
		SM.set_state("Shooting")
