extends Sprite

var target:Node

func _ready():
	pass # Replace with function body.

func _process(_delta):
	var distance = target.position - position + Vector2(0,-100)
	position += distance.normalized() * 7
	
	if distance.length() < 10:
		(target as Player).stun()
		self.queue_free()
