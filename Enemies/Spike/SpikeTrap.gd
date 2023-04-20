extends Area2D


func _ready():
	pass


func _on_SpikeTrap_body_entered(body):
	if body.name == "Player":
		body.damage(10000)
