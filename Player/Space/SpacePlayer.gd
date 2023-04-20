extends KinematicBody2D

var Effects
var UI

onready var SM = $State_Machine
onready var AS = $AnimatedSprite
onready var WJ = $Weapon_Joint

var velocity = Vector2.ZERO
var direction = 1

var gravity = Vector2(0,14)

var reverse_boost = 8
var move_speed = 10
var max_move = 100
var jump_power = 325
var shoot_cooldown = 0.5
var invulnerability_duration = 1

var invulnerable = false
var shooting = false
var detects_ground = true

export var max_health = 64
var health = 64.0
var damage = 15.0

func _ready():
	UI = get_node_or_null("/root/Level/CanvasLayer/UI")
	if UI != null:
		UI.set_max_health(max_health)
		UI.set_health(health)
	health = max_health

func damage(var d):
	if not invulnerable:
		health -= d
		trigger_invulnerable()
		UI = get_node_or_null("/root/Level/CanvasLayer/UI")
		if UI != null:
			UI.set_health(health)
	if health <= 0:
		move_speed = 0
		jump_power = 0
		gravity = Vector2.ZERO
		velocity = Vector2.ZERO
		$AnimatedSprite.play("Death")
		$Weapon_Joint/Weapon_Sprite.visible = false
		var t = Timer.new()
		t.set_wait_time(1.5)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		var _scene = get_tree().change_scene("res://UI/End_Game.tscn")
func trigger_invulnerable():
	invulnerable = true
	var t = Timer.new()
	t.set_wait_time(invulnerability_duration)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	invulnerable = false

func jump():
	velocity = Vector2(velocity.x, velocity.y - (jump_power))

var beamTime = 10


func shoot():
	var line = $Weapon_Joint/Weapon_Muzzle/Line2D
	line.clear_points()
	line.add_point(Vector2.ZERO)
	if $Weapon_Joint/Weapon_Muzzle/Beam_RayCast.is_colliding():
		line.add_point(Vector2(get_global_transform().origin.distance_to($Weapon_Joint/Weapon_Muzzle/Beam_RayCast.get_collision_point()) - 8, 0))
		$Sparks.visible = true
		$Sparks.global_position = $Weapon_Joint/Weapon_Muzzle/Beam_RayCast.get_collision_point()
	else:
		line.add_point($Weapon_Joint/Weapon_Muzzle/Beam_End.position)
		$Sparks.visible = false
	if $Weapon_Joint/Weapon_Muzzle/Enemy_Detect1.is_colliding():
		if $Weapon_Joint/Weapon_Muzzle/Enemy_Detect1.get_collider().has_method("damage"):
			$Weapon_Joint/Weapon_Muzzle/Enemy_Detect1.get_collider().damage((damage / 100.0))
	elif $Weapon_Joint/Weapon_Muzzle/Enemy_Detect2.is_colliding():
		if $Weapon_Joint/Weapon_Muzzle/Enemy_Detect2.get_collider().has_method("damage"):
			$Weapon_Joint/Weapon_Muzzle/Enemy_Detect2.get_collider().damage((damage / 100.0))
	


func _physics_process(_delta):
	$Weapon_Joint.look_at(get_global_mouse_position())
	detects_ground = $Detect_Ground.is_colliding()
	if not shooting:
		velocity.x = clamp(velocity.x,-max_move,max_move)
	else:
		velocity.x = clamp(velocity.x,-max_move * 1.25,max_move * 1.25)
	if direction < 0 and not $AnimatedSprite.flip_h: 
		$AnimatedSprite.flip_h = true
	if direction > 0 and $AnimatedSprite.flip_h: 
		$AnimatedSprite.flip_h = false
	if $AnimatedSprite.flip_h:
		$Weapon_Joint.scale = Vector2(1, -1)
	else:
		$Weapon_Joint.scale = Vector2(1, 1)
	if Input.is_action_pressed("shoot"):
		shooting = true
		shoot()
	else:
		shooting = false
		$Weapon_Joint/Weapon_Muzzle/Line2D.clear_points()
		$Sparks.visible = false

func set_direction(d):
	if not d == 0:
		direction = d

func set_animation(anim):
	#if has same number of frames then set it on same frame as well as long as it is not dash
	if $AnimatedSprite.animation == anim: return
	if $AnimatedSprite.frames.has_animation(anim): 
		$AnimatedSprite.play(anim)
	else: 
		$AnimatedSprite.play()

