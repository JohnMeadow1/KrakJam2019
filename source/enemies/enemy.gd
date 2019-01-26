extends KinematicBody2D
class_name Enemy

export(float) var move_away_time	= 0.8
var move_away_timer:float = 0.0

export(float) var wait_time	= 0.2
var wait_timer:float = 0.0

enum STATES {STATE_IDLE, STATE_SWARE, STATE_WAIT, STATE_CHASE, STATE_RUN, STATE_MOVE_AWAY, STATE_ATTACK}

var state:int       = STATES.STATE_CHASE
var looted:bool     = false
var held_item:Node = null

var target:Node2D	= null
var players:Array = []

export(int) var friends_courage:int = 3
var friends_count:int = 0

func _ready():
	state = STATES.STATE_CHASE

func _on_player_scan_body_entered(body:KinematicBody2D):
	if state == STATES.STATE_ATTACK || state == STATES.STATE_RUN:
		return

	elif body.is_in_group("enemy"):
		friends_count += 1
		if friends_count >= friends_courage:
			state = STATES.STATE_ATTACK
			
			var distance:float = 100000000.0
			for pl in globals.players:
				if (pl.position - self.position).length_squared() < distance:
					distance = (pl.position - self.position).length_squared()
					target = pl

	elif body.is_in_group("player"):
		players.append(body as Node2D)
		if looted == false:
			move_away_timer = move_away_time
			state = STATES.STATE_MOVE_AWAY
	
func _on_player_scan_body_exited(body:KinematicBody2D):
	if body.is_in_group("player"):
		players.erase(body)
	elif body.is_in_group("enemy"):
		friends_count -= 1

func _on_critical_distance_body_entered(body:KinematicBody2D):
	if body.is_in_group("player"):
		state = STATES.STATE_RUN
		drop_loot()

func _on_sware_distance_body_entered(body):
	if state == STATES.STATE_ATTACK || state == STATES.STATE_RUN:
		return
		
	if body.is_in_group("player"):
		state = STATES.STATE_SWARE

func _on_sware_distance_body_exited(body):
	if state == STATES.STATE_ATTACK || state == STATES.STATE_RUN:
		return
	
	if body.is_in_group("player"):
		state = STATES.STATE_CHASE
	
func players_position() -> Vector2:
	var position:Vector2 = Vector2.ZERO
	
	for p in players:
		position += p.position
	
	return position / players.size()
	
func players_target(direction:Vector2):
	if players.size() > 0:
		var playerPos:Vector2 = players_position() - self.position
		if direction.length_squared() - playerPos.length_squared() > 0:
			direction = -playerPos
	
	return direction
	
func grab_loot():
	looted = true
	held_item.grab(16)
	state = STATES.STATE_RUN
	target = globals.camera
	
func drop_loot():
	if held_item:
		held_item.drop()
		held_item = null
		
func _on_VisibilityNotifier2D_screen_exited():
	if state == STATES.STATE_RUN:
		if held_item:
			held_item.queue_free()
		self.queue_free()
