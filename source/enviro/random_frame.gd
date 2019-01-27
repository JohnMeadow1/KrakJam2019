tool
extends StaticBody2D

export(int) onready var frame:int = 0 setget setterfunc, getterfunc


func _ready():
	self.frame = randi()%15
	pass # Replace with function body.

func setterfunc(v):
	if has_node("Sprite"):
		$Sprite.frame = v

func getterfunc():
	if has_node("Sprite"):
		return $Sprite.frame
