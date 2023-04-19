extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	player.set_animation("")

func physics_process(_delta):
	var input_vector = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), 0.0)
	player.velocity += player.move_speed * input_vector + player.gravity
	if player.shooting:
		player.velocity += Vector2.UP.rotated(player.WJ.rotation - PI/2) * player.reverse_boost
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
