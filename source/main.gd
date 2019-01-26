extends Node
func _ready():
	globals.cart = $YSort/cart/pivot/treasure
	globals.players_position = $players_position
	globals.camera = $Camera
	print(globals.cart.name)
	pass # Replace with function body.


func _process(delta):
	handle_players_position()
	handle_camera()

func handle_players_position():
	var target_position = Vector3()
	target_position = $YSort/player_1.position + $YSort/player_2.position + $YSort/player_3.position + $YSort/player_4.position
	target_position *= 0.25
	$players_position.position = target_position

func handle_camera():
	var target_camera_position = Vector3()
	target_camera_position = $YSort/player_1.position + $YSort/player_2.position + $YSort/player_3.position + $YSort/player_4.position + $YSort/cart.position
	target_camera_position *= 0.2
	$Camera.position = lerp($Camera.position, target_camera_position, 0.1)
