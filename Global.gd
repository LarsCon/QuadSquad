extends Node

var vp = null

var score = 0
var lives = 0


func _ready():
	randomize()
	pause_mode = Node.PAUSE_MODE_PROCESS
	vp = get_viewport().size
	var _signal = get_tree().get_root().connect("size_changed",self,"resize")
	reset()



func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		var Pause_Menu = get_node_or_null("/root/UI/Pause_Menu")
		if Pause_Menu == null:
			get_tree().quit()
		else:
			if Pause_Menu.visible:
				Pause_Menu.hide()
				get_tree().paused = false
			else:
				Pause_Menu.show()
				get_tree().paused = true
			

func _resize():
	vp = get_viewport().size
	var HUD = get_node_or_null("/root/Game/UI/HUD")
	if HUD != null:
		HUD.update_()

func update_score(s):
	score += s
	var HUD = get_node_or_null("/root/Game/UI/HUD")
	if HUD != null:
		HUD.update_score()
		
func update_lives(l):
	lives += l
	if lives < 0:
		var _scene = get_tree().change_scene("res://UI/End.Game.tscn")
	else:
		var HUD = get_node_or_null("/root/UI/HUD")
		if HUD != null:
			HUD.update_lives()


func reset():
	score = 0
	lives = 5
