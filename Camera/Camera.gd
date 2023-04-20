extends Camera2D

var Player

func _ready():
	Player = get_node_or_null("/root/Level/Player")

func _physics_process(delta):
	if Player != null:
		global_position = Player.global_position
		print(global_position)
	else:
		print("Null Player")
		Player = get_node_or_null("/root/Level/Player")
