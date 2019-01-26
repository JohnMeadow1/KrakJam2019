extends Node

var goblin_minion_object = load("res://enemies/basic_minion/basic_minion.tscn")
var spawn_distance:float = 500.0

var timer:float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if timer > 0:
		timer -= delta
	else:
		spawn_minion()
		timer = 2.0

func spawn_minion():
	var new_enemy = goblin_minion_object.instance()
	get_parent().add_child(new_enemy)

	var spawn_point:Vector2 = globals.players_position.position - globals.cart.position
	spawn_point = spawn_point.normalized()
	spawn_point *= -spawn_distance
	spawn_point += globals.cart.position
	
	new_enemy.position = spawn_point