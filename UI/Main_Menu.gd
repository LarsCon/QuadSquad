extends Control


func _ready():
	pass


func _on_Play_pressed():
	var _scence = get_tree().change_scene("res://Levels/Space.tscn")


func _on_Quit_pressed():
	get_tree().quit()
