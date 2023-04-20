extends KinematicBody2D

var direction = -1
export var speed = 50
export var damage = 2
export var health = 6

func damage(var d):
	health -= d
	if health <= 0:
		queue_free()

func _ready():
	$AnimatedSprite.play("Movement")
	if direction > 0:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	if not $Detection/Ground_Detection.is_colliding() or $Detection/Wall_Detection.is_colliding():
		turn()
	move_and_slide(Vector2.RIGHT * direction * speed, Vector2.UP)
	if direction > 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

func turn():
	direction *= -1
	$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	$Detection/Ground_Detection.cast_to = Vector2($Detection/Ground_Detection.cast_to.x * -1, $Detection/Ground_Detection.cast_to.y)
	$Detection/Wall_Detection.cast_to = Vector2($Detection/Wall_Detection.cast_to.x * -1, $Detection/Wall_Detection.cast_to.y)

func _on_AttackCollide_body_entered(body):
	if body.name == "Player":
		if body.has_method("damage"):
			body.damage(damage)

