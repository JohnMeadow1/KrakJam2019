extends Node2D

var timer = 0
var start = false

func _process(delta):
	if start:
		timer += delta
		if timer > 2:
			 var ok = get_tree().change_scene_to(load("res://main.tscn"))
	else:
		for i in range(4):
			if Input.is_action_pressed("action_p"+str(i)):
				start = true
				$Sprite2.visible = true
				$Thrust.play()

