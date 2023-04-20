extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	if player.health > 0:
		player.set_animation("Run")

func physics_process(_delta):
	if not player.is_on_floor() and not player.detects_ground:
		SM.set_state("In_Air")
	if Input.is_action_pressed("jump"):
		player.jump()
		SM.set_state("In_Air")
	if Input.is_action_pressed("left") or Input.is_action_pressed("right") or player.shooting:
		var input_vector = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), 0.0)
		player.set_direction(sign(input_vector.x))
		player.velocity += player.move_speed * input_vector
		if player.shooting:
			player.velocity += Vector2.UP.rotated(player.WJ.rotation - PI/2) * player.reverse_boost
		player.move_and_slide(player.velocity, Vector2.UP)
	else:
		player.velocity = Vector2.ZERO
		SM.set_state("Idle")

