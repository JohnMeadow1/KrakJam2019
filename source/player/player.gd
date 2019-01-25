extends KinematicBody

const MOVE_SPEED  = 50
const STUN_TIME   = 1

export(int) var PLAYER_NUM:int = 1
export var player_enabled:bool = false
var PLAYER_CONTROLS:int = 0

enum STATE {STATE_IDLE, STATE_WALK, STATE_FIGHT, STATE_STUN}
var state:int = STATE.STATE_IDLE

var move:Vector3       = Vector3()
var walk_cycle:float     = 0
var timer:float        = 5

var carry_item_handle:Node = null
var originPosition:Vector3 = Vector3()

func _ready():
	PLAYER_CONTROLS  = PLAYER_NUM
	self.state       = STATE.STATE_IDLE
	originPosition   = self.translation
	
func _physics_process(delta):
	if timer > 0:
		timer -= delta
		
	if player_enabled && Input.is_action_just_pressed("action_p" + str(PLAYER_CONTROLS)):
		var pick_up = false
		for node in get_tree().get_nodes_in_group( "pickables"+str(PLAYER_NUM) ):
			node.queue_free()
			globals.add_score(PLAYER_NUM,1)
			pick_up = true
#		if pick_up:
#			get_node("pick_up/Pick_up_" + str( randi() % 4 + 1) ).play()
#		else:
#			get_node("stab/stab_" + str( randi() % 4 + 1) ).play()
#			$AnimationPlayer.play("swing")
#			for body in get_tree().get_nodes_in_group("players"):
#				if body != self && body.translation.distance_to(self.translation) < 3:
#					var direction = body.translation - self.translation
			for body in get_tree().get_nodes_in_group("sage"):
				if body.translation.distance_to(self.translation) < 4:
					body.checkWin(self)

	elif player_enabled :
		var offset = MOVE_SPEED * delta
		var player_moved = handle_input(offset)
	
		if player_moved:
			self.state = STATE.STATE_WALK
			walk_cycle += 0.2
			if walk_cycle >= PI:
				walk_cycle -= PI
#				get_node("steps/Steps_" + str( randi() % 10 + 1 ) ).play()
		elif self.state != STATE.STATE_IDLE:

			if walk_cycle > PI * 0.5:
				walk_cycle += 0.2
			else:
				walk_cycle -= 0.2
				
			if walk_cycle < 0 or walk_cycle > PI:
				if !walk_cycle == 0:
#					get_node("steps/Steps_"+str(randi()%10+1)).play()
					pass
				walk_cycle = 0
				self.state = STATE.STATE_IDLE

	$Spatial.translation.z =  -sin( walk_cycle ) * 0.2
	move                   = move_and_slide(move)
	translation.y      = originPosition.y
	move               *= 0.90

func handle_input(offset):
	var player_moved = false
	if Input.is_action_pressed("move_up_p" + str(PLAYER_CONTROLS)):
		move.z      -= offset
		player_moved = true

	if Input.is_action_pressed("move_down_p" + str(PLAYER_CONTROLS)):
		move.z      += offset
		player_moved = true
	
	if Input.is_action_pressed("move_left_p" + str(PLAYER_CONTROLS)):
		move.x      -= offset
		player_moved = true

	if Input.is_action_pressed("move_right_p" + str(PLAYER_CONTROLS)):
		move.x      += offset
		player_moved = true

	return player_moved