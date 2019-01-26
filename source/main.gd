extends Node
func _ready():
	globals.camera = $Camera
	pass # Replace with function body.


func _process(delta):
	handle_camera()


func handle_camera():
	var target_camera_position = Vector3()
	target_camera_position = $YSort/player_1.position + $YSort/player_2.position + $YSort/player_3.position + $YSort/player_4.position + $YSort/cart.position
	target_camera_position *= 0.2
	$Camera.position = lerp($Camera.position, target_camera_position, 0.1)
