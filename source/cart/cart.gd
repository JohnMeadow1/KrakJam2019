extends KinematicBody2D

export(float) var speed:float = 10.0

var move:Vector2       = Vector2.ZERO

var bump_velcocity:float = 0.0
var loot_in_cart:int = 10
var target_stering:float = 0
var timer:float = 0.0
var current_stering:float = 0.0
var stering_bias:float = 0.0


func _ready():
	randomize()
	globals.wheel = $cart/wheel_position
	globals.cart_node = self

func _physics_process(delta):
	move = Vector2.ZERO
	move.x -= speed 
	move.y += current_stering * 3
	translate(move.normalized() * speed * delta)


func _process(delta):
	timer += delta * 10
	stering_bias += rand_range(-(0.1+stering_bias*0.01), 0.1-stering_bias*0.01 )
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
		
	enemy.grab_loot()
	loot_in_cart -= 1
	
func add_loot():
	loot_in_cart += 1

func _on_bump_area_entered(area):
	area.get_node("Shape2D").disabled = true
	bump_velcocity -= rand_range(1,3)
