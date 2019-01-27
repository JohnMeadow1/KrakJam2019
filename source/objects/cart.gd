extends KinematicBody2D

var speed:float = 5.0
var current_speed:float = 0.0
var move:Vector2       = Vector2.ZERO

var bump_velcocity:float = 0.0
var current_stering:float = 0.0
var target_stering:float = 0
var stering_bias:float = 0.0
var loot_in_cart:float = 0
var timer:float = 0.0

var in_drive_area:int  = 0
var is_driven = false
var spawn_new_loot  = false
var spawn_new_wheel = false
var spawn_new_goat = false
var spawn_new_cart = false
var has_started = false

var loot_object = load("res://objects/loot.tscn")
var wheel_object = load("res://objects/wheel_front.tscn")
var wheels:int = 2
var goat_object = load("res://objects/goat_loot.tscn")
var goats:int = 2
var cart_object = load("res://objects/cart_loot.tscn")
var cart:int = 1

func _ready():
	randomize()
	globals.cart = $treasure
	globals.wheel = $cart/wheel_position
	globals.cart_node = self
	$cart/AnimationPlayer.playback_speed = 0

func _physics_process(delta):
	if cart>0:
		$TextureProgress.value += 1
		if has_started:
			move = Vector2.ZERO
			current_speed = lerp(current_speed, speed, 0.1)
			move.x -= current_speed 
			move.y += current_stering * 3
			move = move_and_slide(move.normalized() * current_speed *(1.5-min(loot_in_cart*0.1,1)) * wheels/2.0 * goats/2.0)
		#	$AnimationPlayer.playback_speed = current_speed/50.0
			$cart/AnimationPlayer.playback_speed = current_speed/100.0
		elif loot_in_cart >=8:
			$AudioStreamPlayer.play()
			has_started = true
		
	
func _process(delta):
	if cart>0:
		if spawn_new_loot:
			spawn_new_loot = false
			spawn_loot()
		if spawn_new_wheel:
			spawn_new_wheel = false
			spaw_wheel()
		if spawn_new_goat:
			spawn_new_goat = false
			spaw_goat()
		if spawn_new_cart:
			spawn_new_cart = false
			spaw_cart()
		timer += delta * 10
		if !is_driven:
			stering_bias += rand_range(-(0.1+stering_bias*0.01), 0.1-stering_bias*0.01 )
			stering_bias = clamp(stering_bias,-0.2,0.2)
			target_stering += stering_bias
			target_stering = clamp(target_stering, -10,10)
		
		current_stering = lerp(current_stering, target_stering, 0.1)
		$goat1.position.y  = abs(sin(timer)*2)-40 + current_stering
		$goat2.position.y = abs(cos(timer)*2)-27 + current_stering
		$shade2.position.y  = -14 + current_stering
		$shade3.position.y = current_stering
		$cart.position.y += bump_velcocity 
		if $cart.position.y < -47  + 10 * (1-wheels/2.0):
			bump_velcocity += 0.5
		else:
			$cart.position.y = -47 + 10 * (1-wheels/2.0)
			bump_velcocity = 0

func _on_VisibilityNotifier_screen_exited():
#	print("wózek poza ekranem")
	pass

func _on_Area2D_body_entered(body):
	var enemy:Enemy = body as Enemy
	
	if not enemy:
		return
	if loot_in_cart > 0:
		spawn_new_loot = true
	elif wheels > 0:
		spawn_new_wheel = true
	elif goats > 0:
		spawn_new_goat = true
	elif cart > 0:
		spawn_new_cart = true
#	enemy.held_item = spawn_loot()
#	enemy.grab_loot()
	enemy.cart_hited()
	get_node("sfx/enemy_hit_"+str(randi()%6+1)).play()

func spaw_wheel():
	var new_wheel = wheel_object.instance()
	get_parent().add_child(new_wheel)
	new_wheel.position = $treasure.global_position
	new_wheel.position.y +=30
	new_wheel.get_node("pivot").position.y -= 40
	new_wheel.velocity = -5
	get_node("cart/wheel_"+str(wheels)).visible = false
	wheels -= 1

func spaw_cart():
	var new_cart = cart_object.instance()
	get_parent().add_child(new_cart)
	new_cart.position = $treasure.global_position + Vector2(-50,0)
	new_cart.get_node("pivot").position.y -= 40
	new_cart.velocity = -5
	cart -=1
	$cart.queue_free()
	$shade.queue_free()
	$TextureProgress.queue_free()
	
func add_wheel():
	wheels += 1
	get_node("cart/wheel_"+str(wheels)).visible = true
	$drop_on_wood.play()
	
func spaw_goat():
	var new_goat = goat_object.instance()
	get_parent().add_child(new_goat)
	new_goat.position = $treasure.global_position -Vector2(100,0)
	new_goat.position.y +=30
	new_goat.get_node("pivot").position.y -= 40
	new_goat.velocity = -5
	get_node("goat"+str(goats)).visible = false
	goats -= 1
	
func add_goat():
	goats += 1
	get_node("goat"+str(goats)).visible = true
	$drop_on_wood.play()
	
func spawn_loot():
	var new_loot = loot_object.instance()
	get_parent().add_child(new_loot)
	new_loot.position = $treasure.global_position
	new_loot.position.y +=30
	new_loot.get_node("pivot").position.y -= 40
	new_loot.velocity = -5
	loot_in_cart = max(loot_in_cart-1, 0)
	$cart.frame = clamp(int(loot_in_cart*0.5), 0, 4)
#	get_node("sfx/pick_gold_"+str(randi()%2+1)).play()
	get_node("sfx/drop_gold_"+str(randi()%3+1)).play()
	return new_loot
	
func add_loot():
	loot_in_cart += 1
	$cart.frame = clamp(int(loot_in_cart*0.5), 0,4)
	$sfx/drop_gold_0.play()
#	$drop_on_wood.play()
#	get_node("sfx/drop_gold_"+str(randi()%3+1)).play()

	
func _on_bump_area_entered(area):
#	dissable_area = true
	for node in area.get_children():
		if node is CollisionShape2D:
			node.queue_free()
#		area.get_node("Shape2D").queue_free()
	bump_velcocity -= rand_range(1,3)
	if randi()%100 < 50:
		if loot_in_cart > 0:
			spawn_new_loot = true
		elif wheels>0:
			spawn_new_wheel = true
		elif goats>0:
			spawn_new_goat = true
	$sfx/wagon_bump_1.play()

func _on_drive_control_body_entered(body):
	if cart>0:
		if !is_driven && in_drive_area == 0:
			$TextureProgress.visible = true
		in_drive_area +=1
		body.can_drive = true


func _on_drive_control_body_exited(body):
	if cart>0:
		in_drive_area -=1
		if in_drive_area == 0:
			$TextureProgress.visible = false
		body.can_drive = false

func get_in(player_id):
	if cart>0:
		$TextureProgress.value -= 2
		if $TextureProgress.value == 0:
			$TextureProgress.value = 60
			$TextureProgress.visible = false
			is_driven = true
			target_stering = 0
			for i in range(4):
				if player_id == i+1:
					get_node("cart/character"+str(i+1)).visible = true 
				else:      
					get_node("cart/character"+str(i+1)).visible = false
			if !has_started:
				has_started = true
				$AudioStreamPlayer.play()
			return true
		return false
	else:
		return false
	
func get_out():
	if cart>0:
		$TextureProgress.value -= 2
		$TextureProgress.visible = true
		if $TextureProgress.value == 0:
			$TextureProgress.value = 60
			$TextureProgress.visible = false
			for i in range(4):   
				get_node("cart/character"+str(i+1)).visible = false
			is_driven = false
			return true
		return false
	else:
		return true
	