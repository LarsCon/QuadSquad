extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	player.set_animation("")

func physics_process(_delta):
	if not player.is_on_floor() and not player.detects_ground:
		SM.set_state("In_Air")
	if Input.is_action_pressed("jump"):
		player.jump()
		SM.set_state("In_Air")
	if Input.is_action_pressed("left") or Input.is_action_pressed("right") or player.shoot_launch or not player.can_shoot:
		var input_vector = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), 0.0)
		player.set_direction(sign(input_vector.x))
		player.velocity += player.move_speed * input_vector
		if player.shoot_launch:
			player.velocity = Vector2.ZERO
			player.velocity += Vector2.UP.rotated(player.WJ.rotation - PI/2) * player.reverse_boost
			player.added_x_velocity = abs((Vector2.UP.rotated(player.WJ.rotation - PI/2) * player.reverse_boost).x)
			SM.set_state("In_Air")
			player.shoot_launch = false
		player.move_and_slide(player.velocity, Vector2.UP)
	else:
		player.velocity = Vector2.ZERO
		SM.set_state("Idle")
	if Input.is_action_just_pressed("shoot") and player.can_shoot and not player.cooldown:
		player.can_shoot = false
		SM.set_state("Shooting")

