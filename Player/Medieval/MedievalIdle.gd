extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	player.set_animation("Idle")

func physics_process(_delta):
	player.can_shoot = true
	if not player.is_on_floor() and not player.detects_ground:
		SM.set_state("In_Air")
	if Input.is_action_pressed("left") or Input.is_action_pressed("right") or player.shoot_launch:
		SM.set_state("Moving")
	if Input.is_action_pressed("jump"):
		player.jump()
		SM.set_state("In_Air")
	if Input.is_action_just_pressed("shoot") and player.can_shoot and not player.cooldown:
		player.can_shoot = false
		SM.set_state("Shooting")
