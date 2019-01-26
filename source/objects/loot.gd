extends Node2D

var sprites = [ "res://objects/loot_0.png", 
				"res://objects/loot_1.png",
				"res://objects/loot_2.png",
				"res://objects/loot_3.png",
				"res://objects/loot_4.png",
				"res://objects/loot_5.png"]

var sfx_drop = []
var sfx_pick = []

var is_held = false
var velocity = 0.0

var pickup_height = 0.0

func _ready():
	$pivot/sprite.texture = load(sprites[randi()%sprites.size()])
	
	sfx_drop = [ $sfx/drop_gold_1,
				 $sfx/drop_gold_2,
				 $sfx/drop_gold_3 ]
	sfx_pick = [ $sfx/pick_gold_1,
				 $sfx/pick_gold_2 ]
	
func _process(delta):
	if is_held:
		$pivot.position.y = lerp($pivot.position.y, -pickup_height, 0.2)
		
	elif $pivot.position.y < 0:
		velocity += 1.0
		velocity *= 0.95
		$pivot.position.y += velocity
		if $pivot.position.y > 1:
			$pivot.position.y -= velocity
			velocity *= -0.90
	else:
		velocity = 0.0
	$shade.modulate.a = 1-clamp(-$pivot.position.y/10,0,1)
	
func grab(height):
	$Shape2D.disabled = true
	is_held = true
	pickup_height = height
	(sfx_pick[randi() % sfx_pick.size()] as AudioStreamPlayer).play()
	
func drop():
	$Shape2D.disabled = false
	is_held = false
	(sfx_drop[randi() % sfx_drop.size()] as AudioStreamPlayer).play()
