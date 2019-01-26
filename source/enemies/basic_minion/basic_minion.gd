extends KinematicBody2D

enum {STATE_IDLE, STATE_RUN, STATE_CHASE}

export(float) var chase_speed:float = 75.0

var state        = null

var originPosition = Vector3()
var target         = null

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_tree().get_nodes_in_group("cart").front()
	originPosition = self.position
	state = STATE_CHASE

func _physics_process(delta):
	if state == STATE_IDLE:
		idle(delta)
	elif state == STATE_CHASE && target != null:
		chase(delta)
	else:
		idle(delta)

func idle(delta):
	pass
	
func chase(delta):
	var offset = chase_speed * delta
	var direction = target.position - self.position
	direction = direction.normalized()
	
	self.move_and_slide(direction * offset)