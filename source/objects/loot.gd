extends Area2D

var sprites = [ "res://sprites/loot_0.png", 
				"res://sprites/loot_1.png",
				"res://sprites/loot_2.png",
				"res://sprites/loot_3.png",
				"res://sprites/loot_4.png",
				"res://sprites/loot_5.png"]

var sfx_drop = []
var sfx_pick = []

var is_held = false
var velocity = 0.0

var enemy_terget:Enemy = null
var pickup_height = 0.0

func _ready():
	$pivot/sprite.texture = load(sprites[randi()%sprites.size()])
	
	sfx_drop = [ $sfx/drop_gold_1,
				 $sfx/drop_gold_2,
				 $sfx/drop_gold_3 ]
	sfx_pick = [ $sfx/pick_gold_1,
				 $sfx/pick_gold_2 ]
	
func _process(_delta):
	if is_held:
		$pivot.position.y = lerp($pivot.position.y, -pickup_height, 0.2)
		$Shape2D.disabled = true
		
		
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
	
func grab(height, who:Node):
	is_held = true
	pickup_height = height
	self.remove_from_group("loot")
	(sfx_pick[randi() % sfx_pick.size()] as AudioStreamPlayer).play()
	if enemy_terget && enemy_terget is Enemy:
		if(who.is_in_group("player")):
			enemy_terget.attack_player(who)
		else:
			enemy_terget.chose_new_target()
	
func drop():
	is_held = false
	self.add_to_group("loot")
	(sfx_drop[randi() % sfx_drop.size()] as AudioStreamPlayer).play()

func target(enemy:Enemy):
	enemy_terget = enemy

func _on_VisibilityNotifier2D_screen_entered():
	self.add_to_group("loot")
	pass

func _on_VisibilityNotifier2D_screen_exited():
	self.remove_from_group("loot")
	pass

