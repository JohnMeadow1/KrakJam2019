extends Node
func _ready():
	globals.players_position = $players_position
	globals.camera = $Camera
	globals.players.append( $YSort/player_1 )
	globals.players.append( $YSort/player_2 )
	globals.players.append( $YSort/player_3 )
	globals.players.append( $YSort/player_4 )
	pass # Replace with function body.

func _process(_delta):
	handle_players_position()
	handle_camera()

func handle_players_position():
	var target_position = Vector3()
	target_position = $YSort/player_1.position + $YSort/player_2.position + $YSort/player_3.position + $YSort/player_4.position
	target_position *= 0.25
	$players_position.position = target_position

func handle_camera():
	var target_camera_position = Vector3()
#	target_camera_position =  ($YSort/player_1.position) * $YSort/player_1.enabled_timer 
#	target_camera_position += ($YSort/player_2.position) * $YSort/player_2.enabled_timer 
#	target_camera_position += ($YSort/player_3.position) * $YSort/player_3.enabled_timer 
#	target_camera_position += ($YSort/player_4.position) * $YSort/player_4.enabled_timer 
#	print($YSort/player_1.enabled_timer)
	target_camera_position =  $YSort/cart.position
	target_camera_position += ($YSort/player_1.position-$YSort/cart.position) * $YSort/player_1.enabled_timer *0.5
	target_camera_position += ($YSort/player_2.position-$YSort/cart.position) * $YSort/player_2.enabled_timer *0.5
	target_camera_position += ($YSort/player_3.position-$YSort/cart.position) * $YSort/player_3.enabled_timer *0.5
	target_camera_position += ($YSort/player_4.position-$YSort/cart.position) * $YSort/player_4.enabled_timer *0.5

#	target_camera_position /= 5.0
#	target_camera_position /= 1+($YSort/player_1.enabled_timer + $YSort/player_2.enabled_timer +$YSort/player_3.enabled_timer +$YSort/player_4.enabled_timer )
	$Camera.position = lerp($Camera.position, target_camera_position, 0.1)
	$Camera.position.x = min($Camera.position.x,-0 )