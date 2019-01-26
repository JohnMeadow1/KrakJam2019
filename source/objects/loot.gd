extends Node2D

var sprites = [ "res://sprites/loot.png", 
				"res://sprites/loot.png"]
				
var is_held = false
var velocity = 0.0

var pickup_height = 0.0

func _ready():
	$Node2D/sprite.texture = load(sprites[randi()%sprites.size()])
	
func _process(delta):
	if is_held:
		$Node2D.position.y = lerp($Node2D.position.y, -pickup_height, 0.2)
		
	elif $Node2D.position.y < 0:
		velocity += 1.0
		velocity *= 0.95
		$Node2D.position.y += velocity
		if $Node2D.position.y > 1:
			$Node2D.position.y -= velocity
			velocity *= -0.90
	else:
		velocity = 0.0
	$shade.modulate.a = 1-clamp(-$Node2D.position.y/10,0,1)
	
func grab(height):
	$Shape2D.disabled = true
	is_held = true
	pickup_height = height
	
func drop():
	$Shape2D.disabled = false
	is_held = false
