extends Node

var goblin_minion_object = load("res://enemies/basic_minion/basic_minion.tscn")
var spawn_distance:float = 600.0

var timer:float = 3.0
export(float) var spawn_time_max:float = 4.0
export(float) var spawn_time_min:float = 2.5
var spawn_time:float = 5.0

var enemy_courge_level:int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 10
	pass # Replace with function body.

func _process(delta):
	if timer > 0:
		timer -= delta
	else:
		spawn_minion()
		if globals.cart_node.position.x > -8500:
			spawn_time = (1 - abs(globals.cart_node.position.x)/9000) * spawn_time_max + spawn_time_min
			spawn_time /= max(globals.active_players*0.75, 1.0)
		else:
			spawn_time = 0.5
			enemy_courge_level = 7
		timer = spawn_time

func spawn_minion():
#	if globals.cart_node.loot_in_cart + get_tree().get_nodes_in_group("loot").size() <= 0:
#		return
	
	var new_enemy = goblin_minion_object.instance()
	new_enemy.friends_courage = enemy_courge_level
	get_parent().add_child(new_enemy)

#	var spawn_point:Vector2 = Vector2(randf(), randf())
#	var spawn_point:Vector2 = globals.players_position.position - globals.cart.global_position
	var spawn_point:Vector2 = globals.camera.position - globals.cart.global_position
	spawn_point = spawn_point.normalized()
	spawn_point += Vector2(rand_range(-0.5,0.5),rand_range(-0.5,0.5))
	spawn_point = spawn_point.normalized()
	spawn_point *= -spawn_distance
	spawn_point += globals.cart.global_position
	
	new_enemy.position = spawn_point