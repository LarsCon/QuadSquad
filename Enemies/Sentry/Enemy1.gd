extends StaticBody2D

var Effects
onready var Projectile = load("res://Enemies/Sentry/Enemy_Projectile.tscn")

var player

export var health = 10

var cooldown = false
var attacking = false

export var attack_rate = 1 #every time the idle animation runs # of times then it attackings
export var attacking_range = 500

var attacking_direction
var can_switch_animation = true
var shot = false #how many times has shot per attack

export var damage = 2

func _physics_process(delta):
	player = get_node_or_null("/root/Level/Player")
	if not player == null:
		if attacking:
			attacking()
		elif not cooldown:
			if can_attack() != Vector2.ZERO:
				attacking_direction = can_attack()
				attacking()
		elif cooldown:
			idle()
		if not attacking:
			if player.global_position.x - global_position.x < 0:
				scale = Vector2(1, 1)
			else:
				scale = Vector2(-1, 1)

#If the player attack finished then start timer
func cooldown_timer(var time):
	cooldown = true
	var t = Timer.new()
	t.set_wait_time(time)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	cooldown = false

func _on_AttackCollide_body_entered(body):
	if body.name == "Player":
		if body.has_method("damage"):
			body.damage(damage)

func idle():
	pass

func can_attack():
	if global_position.distance_to(player.global_position) <= attacking_range:
		var detect_terrain = $Detect_Terrain
		detect_terrain.cast_to = player.global_position - global_position
		if not detect_terrain.is_colliding(): #if not colliding with terrain
			var dir = (player.global_position - global_position).normalized()
			return dir
	return Vector2.ZERO

func attacking():
	if not attacking:
		$AnimatedSprite.play("Shoot")
		attacking = true
	else:
		if $AnimatedSprite.frame == 2 && not shot:
			shot = true
			generate_projectile(attacking_direction)
			#if $Line2D.get_point_count() != 0:
			#	$Line2D.clear_points()
			#$Line2D.add_point($Gun.global_position - global_position)
			#$Line2D.add_point(attacking_direction*100.0)
		elif $AnimatedSprite.frame == 4:
			$AnimatedSprite.play("Idle")
			cooldown_timer(attack_rate)
			attacking = false
			shot = false
			#if $Line2D.get_point_count() != 0:
			#	$Line2D.clear_points()

func generate_projectile(var vector):
	Effects = get_node_or_null("/root/Level/Effects")
	if Effects != null and Projectile != null:
		var projectile = Projectile.instance()
		Effects.add_child(projectile)
		projectile.global_position = $Gun.global_position
		projectile.direction = vector
		projectile.damage = damage

func damage(var d):
	health -= d
	if health <= 0:
		queue_free()





