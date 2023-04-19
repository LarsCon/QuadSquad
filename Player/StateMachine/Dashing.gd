extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	player.set_animation("Dash")

func physics_process(_delta):
	player.can_dash = false
	if (not player.dashing):
		player.dash_direction = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), Input.get_action_strength("down") - Input.get_action_strength("up"))
		if player.dash_direction.x == 0 and player.dash_direction.y == 0:
			if not player.AS.flip_h:
				player.dash_direction = Vector2(1, player.dash_direction.y)
			else:
				player.dash_direction = Vector2(-1, player.dash_direction.y)
	var input_vector = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),0.0)
	player.dashing = true
	var frame = player.AS.frame
	var total_frame = player.AS.frames.get_frame_count("Dash")
	player.move_and_slide(player.dash_direction * player.dash_speed, Vector2.UP)
	player.velocity = player.dash_direction * player.max_move
	if frame >= 4:
		player.set_direction(sign(input_vector.x))
	if total_frame - 1 == frame:
		player.dashing = false
		SM.set_state("In_Air")
