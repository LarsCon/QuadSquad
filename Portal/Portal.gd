extends Area2D

export var next_scene_path = ""

func _on_Portal_body_entered(body):
	if body.name == "Player":
		var _scene = get_tree().change_scene(next_scene_path)
