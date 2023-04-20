extends KinematicBody2D

var Effects
var UI

onready var SM = $State_Machine
onready var AS = $AnimatedSprite
onready var WJ = $Weapon_Joint

var velocity = Vector2.ZERO
var added_x_velocity = 0.0

var direction = 1

var gravity = Vector2(0,14)

var reverse_boost = 400
var move_speed = 10
var max_move = 100
var jump_power = 325
var shoot_cooldown = 1.25
var invulnerability_duration = 1

var invulnerable = false
var shoot_launch = false
var detects_ground = true
var cooldown = false

var can_shoot = true

export var max_health = 5
var health = 5.0
var damage = 5.0

var shoot_power = 0.0

func _ready():
	UI = get_node_or_null("/root/Level/CanvasLayer/UI")
	if UI != null:
		UI.set_max_health(max_health)
		UI.set_health(health)
	health = max_health

func damage(var d):
	print(health)
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


func shoot():
	shoot_launch = true
	$Weapon_Joint/Weapon_Muzzle/Particles_Weapon.emitting = true
	if $Weapon_Joint/Weapon_Muzzle/Enemy_Detect.is_colliding():
		if $Weapon_Joint/Weapon_Muzzle/Enemy_Detect.get_collider().has_method("damage"):
			$Weapon_Joint/Weapon_Muzzle/Enemy_Detect.get_collider().damage(damage)
		$Weapon_Joint/Weapon_Muzzle/Particles_Enemy.global_position = $Weapon_Joint/Weapon_Muzzle/Enemy_Detect.get_collision_point()
		$Weapon_Joint/Weapon_Muzzle/Particles_Enemy.emitting = true
	cooldown_timer(shoot_cooldown)

func cooldown_timer(var time):
	cooldown = true
	var t = Timer.new()
	t.set_wait_time(time)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	$Weapon_Joint/Weapon_Muzzle/Particles_Weapon.emitting = false
	$Weapon_Joint/Weapon_Muzzle/Particles_Enemy.emitting = false
	cooldown = false
	

func _physics_process(_delta):
	$Weapon_Joint.look_at(get_global_mouse_position())
	detects_ground = $Detect_Ground.is_colliding()
	if can_shoot:
		velocity.x = clamp(velocity.x,-max_move,max_move)
	else:
		velocity.x = clamp(velocity.x,-max_move - added_x_velocity,max_move + added_x_velocity)
		added_x_velocity = clamp(added_x_velocity - 5, 0, 1000000.0)
	if direction < 0 and not $AnimatedSprite.flip_h: 
		$AnimatedSprite.flip_h = true
	if direction > 0 and $AnimatedSprite.flip_h: 
		$AnimatedSprite.flip_h = false
	if $AnimatedSprite.flip_h:
		$Weapon_Joint.scale = Vector2(1, -1)
	else:
		$Weapon_Joint.scale = Vector2(1, 1)

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

