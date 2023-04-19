extends KinematicBody2D

var Effects
var UI

onready var Projectile = load("res://Player/Player_Projectile.tscn")

onready var SM = $State_Machine
onready var AS = $AnimatedSprite

var velocity = Vector2.ZERO
var direction = 1

export var gravity = Vector2(0,14)

export var move_speed = 10
export var max_move = 100
export var jump_power = 325
export var dash_speed = 300
export var apex_velocity_threshold = 100
export var shoot_cooldown = 0.5
export var invulnerability_duration = 1

var in_air_value = 1 #either 0, 1, or 2 representing whether it is going up, at the apex of the jump, or falling
var dash_direction = Vector2(0, 1)

var shooting = false
var dashing = false
var can_dash = true
var invulnerable = false

var detects_ground = false

export var max_health = 64
var health = 64

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
		can_dash = false
		gravity = Vector2.ZERO
		velocity = Vector2.ZERO
		$AnimatedSprite.visible = false
		var t = Timer.new()
		t.set_wait_time(1.0)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		#var _scene = get_tree().change_scene("res://UI/End_Game.tscn")

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
	shooting = true
	var input = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), Input.get_action_strength("down") - Input.get_action_strength("up"))
	if input.x == 0:
		input = Vector2(direction, input.y)
	generate_bullet(input)
	var t = Timer.new()
	t.set_wait_time(shoot_cooldown)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	shooting = false

func generate_bullet(var vector):
	Effects = get_node_or_null("/root/Level/Effects")
	if Effects != null:
		var projectile = Projectile.instance()
		Effects.add_child(projectile)
		if vector.y == -1:
			projectile.global_position = $Gun/Upward.global_position
		elif vector.y == 1:
			projectile.global_position = $Gun/Downward.global_position
		else: #forward
			projectile.global_position = $Gun/Forward.global_position
		projectile.direction = vector
		projectile._ready()

func _physics_process(_delta):
	detects_ground = $Detect_Ground.is_colliding()
	velocity.x = clamp(velocity.x,-max_move,max_move)
	if direction < 0 and not $AnimatedSprite.flip_h: 
		$AnimatedSprite.flip_h = true
	if direction > 0 and $AnimatedSprite.flip_h: 
		$AnimatedSprite.flip_h = false
	if $AnimatedSprite.flip_h:
		$Gun.scale = Vector2(-1, 1)
	else:
		$Gun.scale = Vector2(1, 1)
	if dashing:
		collision_layer = 64 #only layer 7
	else:
		collision_layer = 3

func set_direction(d):
	if not d == 0:
		direction = d

func set_animation(anim):
	#if has same number of frames then set it on same frame as well as long as it is not dash
	if $AnimatedSprite.animation == anim: return
	if $AnimatedSprite.frames.has_animation(anim): 
		var frameCount = $AnimatedSprite.frames.get_frame_count($AnimatedSprite.animation)
		var frame = $AnimatedSprite.frame
		$AnimatedSprite.play(anim)
		if not anim == "Dash":
			if frameCount == $AnimatedSprite.frames.get_frame_count($AnimatedSprite.animation):
				$AnimatedSprite.frame = frame
			elif frameCount - 4 == $AnimatedSprite.frames.get_frame_count($AnimatedSprite.animation):
				$AnimatedSprite.frame = frame - 4
			elif frameCount == $AnimatedSprite.frames.get_frame_count($AnimatedSprite.animation) - 4:
				$AnimatedSprite.frame = frame + 4
	else: 
		$AnimatedSprite.play()

