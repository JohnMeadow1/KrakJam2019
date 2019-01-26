extends Enemy

export(float) var chase_speed:float 	= 75.0
export(float) var run_speed:float		= 120.0
export(float) var charge_speed:float	= 250.0

export(float) var attack_distance = 70.0
# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_tree().get_nodes_in_group("treasure").front()

func _physics_process(delta):
	if state == STATES.STATE_ATTACK:
		charge(delta)
	elif state == STATES.STATE_RUN && target != null:
		run(delta)
	elif state == STATES.STATE_CHASE && target != null:
		chase(delta)
	elif state == STATES.STATE_MOVE_AWAY:
		if	move_away_timer > 0:
			move_away_timer -= delta
			move_away(delta)
		else:
			wait_timer = wait_time
			state = STATES.STATE_WAIT
	elif state == STATES.STATE_WAIT:
		if	wait_timer > 0:
			wait_timer -= delta
		else:
			state = STATES.STATE_CHASE
	else:
		idle(delta)

func idle(delta):
	pass
	
func chase(delta):
	var offset = chase_speed * delta * 100.0
	var direction = target.global_position - self.position
	
	direction = players_target(direction)
	direction = direction.normalized()
	
	self.move_and_slide(direction * offset)
	
func run(delta):
	var lootDrag = 1
	if held_item:
		lootDrag = 0.3
		target = globals.camera
		held_item.position = lerp(held_item.position,$pivot/held_item.global_position, 0.2)
	else:
		target = globals.players_position
	
	var offset = run_speed * delta * lootDrag * 100.0
	var direction = self.position - target.global_position
	
	direction = players_target(direction)
	direction = direction.normalized()
	
	self.move_and_slide(direction * offset)

func move_away(delta):
	if players.size() > 0:
		move_away_timer = move_away_time
	
	var offset = run_speed * delta * 100.0
	var direction = self.position - globals.players_position.global_position
	direction = direction.normalized()
	
	self.move_and_slide(direction * offset)

func charge(delta):
	var offset = chase_speed * delta * 100.0
	var direction = target.global_position - self.position
	if direction.length() <= attack_distance:
		state = STATES.STATE_RUN
		run_speed = charge_speed
		(target as Player).stun()
	
	direction = direction.normalized()
	self.move_and_slide(direction * offset)