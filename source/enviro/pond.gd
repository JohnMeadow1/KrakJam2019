extends Node2D

func _ready():
	if randi()%2:
		$Sprite2.flip_h = true

