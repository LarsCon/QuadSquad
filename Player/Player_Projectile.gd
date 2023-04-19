extends KinematicBody2D

var direction = Vector2.ZERO
export var speed = 250
export var damage = 2

func _ready():
	$Sprite_Transform/AnimatedSprite.play("default")
	rotation_degrees = rad2deg(direction.angle())

func _physics_process(delta):
	move_and_slide(direction * speed, Vector2.UP)

func _on_Timer_timeout():
	queue_free()

func _on_AttackCollide_body_entered(body):
	if body.name != "Player":
		if body.has_method("damage"):
			body.damage(damage)
	queue_free()
