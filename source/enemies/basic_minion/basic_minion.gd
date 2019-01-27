extends Enemy

export(float) var chase_speed:float 	= 75.0
export(float) var run_speed:float		= 120.0
export(float) var charge_speed:float	= 250.0

export(float) var attack_distance = 100.0

var curent_run_speed:float = 0.0
var rock_object = load("res://objects/throw_rock.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	chose_new_target()

func _physics_process(delta):
	if state == STATES.STATE_ATTACK:
		charge(delta)
	elif state == STATES.STATE_RUN && target is Node:
		run(delta)
	elif state == STATES.STATE_SWARE:
		sware(delta)
	elif state == STATES.STATE_CHASE && target is Node:
		chase(delta)
	elif state == STATES.STATE_MOVE_AWAY:
		if move_away_timer > 0:
			move_away_timer -= delta
			move_away(delta)
		else:
			wait_timer = wait_time
			state = STATES.STATE_WAIT
			$pivot/AnimationPlayer.play("go_home")
	elif state == STATES.STATE_WAIT:
		if wait_timer > 0:
			wait_timer -= delta
		else:
			state = STATES.STATE_CHASE
	else:
		idle(delta)

func idle(_delta):
	pass
	
func chase(delta):
	var offset = chase_speed * delta * 100.0
	var direction = Vector2()
	if target is Node:
		direction = target.global_position - self.position
	else:
		chose_new_target()
#	direction = players_target(direction)
	direction = direction.normalized()
	
	direction = move_and_slide(direction * offset)
	
func run(_delta):
	var lootDrag = 1
	if held_item is Node:
		lootDrag = 0.3
		target   = globals.camera
		held_item.position = lerp(held_item.position,$pivot/held_item.global_position, 0.2)
	else:
		target = globals.players_position
	curent_run_speed = lerp(curent_run_speed, run_speed, 0.1)
	var offset = curent_run_speed * _delta * lootDrag * 100.0
	var direction = self.position - target.global_position
	
	direction = players_target(direction)
	direction = direction.normalized()
	
	direction = move_and_slide(direction * offset)

func sware(_delta):
	$pivot/AnimationPlayer.play("go_home")

func move_away(delta):
	if players.size() > 0:
		move_away_timer = move_away_time
	curent_run_speed = lerp(curent_run_speed, run_speed, 0.1)
	var offset = run_speed * delta * 100.0
	var direction = self.position - globals.players_position.global_position
	direction = direction.normalized()
	
	direction = move_and_slide(direction * offset)

func charge(delta):
	var offset = chase_speed * delta * 100.0
	var direction = target.global_position - self.position
	if target is Node:
		if direction.length() <= attack_distance:
			state = STATES.STATE_RUN
			run_speed = charge_speed
			$pivot/AnimationPlayer.play("throw")
			throw_rock()

	else:
		chose_new_target()
	
	direction = direction.normalized()
	direction = move_and_slide(direction * offset)
	
func throw_rock():
	$throw.play()
	var new_rock = rock_object.instance()
	get_parent().add_child( new_rock )
	new_rock.target = target
	new_rock.position = position + Vector2(0,-50)
#	(target as Player).stun()
	
func _on_pickup_area_loot_entered(area):
	if area == target:
		held_item = target
		target.grab(30, self)
		state = STATES.STATE_RUN
