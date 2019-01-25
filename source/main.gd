extends Node
func _ready():
	pass # Replace with function body.


func _process(delta):
	handle_camera()


func handle_camera():
	var target_camera_position = Vector3()
	target_camera_position = $player_1.translation + $player_2.translation + $player_3.translation + $player_4.translation + $cart.translation
	target_camera_position *= 0.2
	target_camera_position.y = $Camera.translation.y
	target_camera_position.z += 3.0
	$Camera.translation = lerp($Camera.translation, target_camera_position, 0.1)
