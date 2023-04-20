extends Area2D


func _ready():
	#$AnimationPlayer.play("NAME OF ANIMATION IF WE WANT ONE For The Spike")
	pass


func _on_SpikeTrap_body_entered(body):
	if body.name == "Player":
		body.damage(10000)
