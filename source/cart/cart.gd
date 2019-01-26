extends KinematicBody2D

export(float) var speed:float = 10.0
var current_speed:float = 0.0
var move:Vector2       = Vector2.ZERO

var bump_velcocity:float = 0.0
var current_stering:float = 0.0
var target_stering:float = 0
var stering_bias:float = 0.0
var loot_in_cart:int = 5
var timer:float = 0.0

var in_drive_area:int  = 0
#var drive_progress:int = 20
var is_driven = false

var loot_object = load("res://objects/loot.tscn")

func _ready():
	randomize()
	globals.wheel = $cart/wheel_position
	globals.cart_node = self

func _physics_process(delta):
#	drive_progress = clamp(drive_progress + 1,0,20)
	$TextureProgress.value += 1
	move = Vector2.ZERO
	current_speed = lerp(current_speed, speed, 0.1)
	move.x -= current_speed 
	move.y += current_stering * 3
	translate(move.normalized() * current_speed * delta)
#	$AnimationPlayer.playback_speed = current_speed/50.0
	$cart/AnimationPlayer.playback_speed = current_speed/100.0
func _process(delta):
	timer += delta * 10
	if !is_driven:
		stering_bias += rand_range(-(0.1+stering_bias*0.01), 0.1-stering_bias*0.01 )
		stering_bias = clamp(stering_bias,-0.2,0.2)
		target_stering += stering_bias
		target_stering = clamp(target_stering, -10,10)

	current_stering = lerp(current_stering, target_stering, 0.1)
	$goat.position.y  = abs(sin(timer)*2)-40 + current_stering
	$goat2.position.y = abs(cos(timer)*2)-27 + current_stering
	$cart.position.y += bump_velcocity 
	if $cart.position.y < -47:
		bump_velcocity += 0.5
	else:
		$cart.position.y = -47
		bump_velcocity = 0

func _on_VisibilityNotifier_screen_exited():
	print("wózek poza ekranem")
	pass


func _on_Area2D_body_entered(body):
	var enemy:Enemy = body as Enemy
	
	if not enemy:
		return
	enemy.held_item = spawn_loot()
	enemy.grab_loot()
	
func spawn_loot():
	var new_loot = loot_object.instance()
	get_parent().add_child(new_loot)
	new_loot.position = $treasure.global_position
	new_loot.position.y +=30
	loot_in_cart -= 1
	$cart.frame = int(loot_in_cart*0.5)
	return new_loot
	
func add_loot():
	loot_in_cart += 1
	$cart.frame = clamp(int(loot_in_cart*0.5), 0,4)

func _on_bump_area_entered(area):
	area.get_node("Shape2D").disabled = true
	bump_velcocity -= rand_range(1,3)
	if randi()%100 < 50:
		var new_loot = spawn_loot()
		new_loot.get_node("pivot").position.y -= 40
		new_loot.velocity = -5

func _on_drive_control_body_entered(body):
	if !is_driven && in_drive_area == 0:
		$TextureProgress.visible = true
	in_drive_area +=1
	body.can_drive = true


func _on_drive_control_body_exited(body):
	in_drive_area -=1
	if in_drive_area == 0:
		$TextureProgress.visible = false
	body.can_drive = false

func get_in(player_id):
	$TextureProgress.value -= 2
	if $TextureProgress.value == 0:
		$TextureProgress.visible = false
		is_driven = true
		target_stering = 0
		for i in range(4):
			if player_id == i:
				get_node("cart/character"+str(i+1)).visible = true 
			else:      
				get_node("cart/character"+str(i+1)).visible = false
		return true
	return false
