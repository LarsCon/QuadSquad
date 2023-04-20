extends Control


func _ready():
	pass


func _on_Restart_pressed():
	Global.reset()
	get_tree().paused = false
	var _scene = get_tree().change_scene("res://Levels/Space.tscn")


func _on_Quit_pressed():
	get_tree().quit()
