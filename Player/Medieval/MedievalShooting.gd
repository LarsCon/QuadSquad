extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	if player.health <= 0:
		player.set_animation("")

func physics_process(_delta):
	if Input.is_action_just_released("shoot"):
		player.shoot()
		if not player.is_on_floor() and not player.detects_ground:
			SM.set_state("In_Air")
		else:
			SM.set_state("Idle")
		player.shoot_power = 0
	else:
		player.shoot_power = clamp(player.shoot_power + (_delta) * 15.0, 0.0, player.max_power)
