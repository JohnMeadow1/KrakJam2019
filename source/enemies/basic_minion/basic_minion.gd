extends Enemy

export(float) var chase_speed:float = 75.0
export(float) var run_speed:float = 120.0

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_tree().get_nodes_in_group("treasure").front()

func _physics_process(delta):
	if state == STATES.STATE_IDLE:
		idle(delta)
	elif state == STATES.STATE_CHASE && target != null:
		chase(delta)
	elif state == STATES.STATE_RUN:
		run(delta)
	else:
		idle(delta)

func idle(delta):
	pass
	
func chase(delta):
	var offset = chase_speed * delta * 100.0
	var direction = target.global_position - self.position
	direction = direction.normalized()
	
	self.move_and_slide(direction * offset)
	
func run(delta):
	var lootDrag = 1
	if has_loot: lootDrag = 0.5
	var offset = run_speed * delta * lootDrag * 100.0
	var direction = self.position - target.global_position
	direction = direction.normalized()
	
	self.move_and_slide(direction * offset)