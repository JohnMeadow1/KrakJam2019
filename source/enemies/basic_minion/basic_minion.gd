extends Enemy

export(float) var chase_speed:float = 75.0
export(float) var run_speed:float	= 120.0


# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_tree().get_nodes_in_group("treasure").front()
	print(state)

func _physics_process(delta):
	if state == STATES.STATE_IDLE:
		idle(delta)
	elif state == STATES.STATE_CHASE && target != null:
		chase(delta)
	elif state == STATES.STATE_RUN && target != null:
		run(delta)
	elif state == STATES.STATE_MOVE_AWAY:
		if	move_away_timer > 0:
			move_away_timer -= delta
			move_away(delta)
		else:
			state = STATES.STATE_CHASE
		pass
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
	if has_loot:
		lootDrag = 0.5
		target = globals.camera
	else:
		target = globals.players_position
	
	var offset = run_speed * delta * lootDrag * 100.0
	var direction = self.position - target.global_position
	
	direction = players_target(direction)
	direction = direction.normalized()
	
	self.move_and_slide(direction * offset)

func move_away(delta):
	var offset = run_speed * delta * 100.0
	var direction = self.position - globals.players_position.global_position
	direction = direction.normalized()
	
	self.move_and_slide(direction * offset)

