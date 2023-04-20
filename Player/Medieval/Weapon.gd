extends KinematicBody2D

var direction = Vector2.ZERO
var speed = 200
var damage = 2
var moving = true

func ready():
	if direction.x > 0:
		$Weapon_Sprite.flip_h = true
	rotation_degrees = rad2deg(direction.angle())
	moving = true

func _physics_process(delta):
	if moving:
		move_and_slide(direction * speed, Vector2.UP)

func _on_Timer_timeout():
	queue_free()

func _on_AttackCollide_body_entered(body):
	print(body.name)
	if body.name != "Player":
		var pos = global_position
		self.get_parent().remove_child(self)
		body.add_child(self)
		global_position = pos
		if body.has_method("damage"):
			body.damage(damage)
		print(self.get_parent().name)
		moving = false
