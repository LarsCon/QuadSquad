extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	player.set_animation("Idle")

func physics_process(_delta):
	if not player.is_on_floor() and not player.detects_ground:
		SM.set_state("In_Air")
	if Input.is_action_pressed("left") or Input.is_action_pressed("right") or player.shooting:
		SM.set_state("Moving")
	if Input.is_action_pressed("jump"):
		player.jump()
		SM.set_state("In_Air")
