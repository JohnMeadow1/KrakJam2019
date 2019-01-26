extends KinematicBody2D
class_name Enemy

export(float) var move_away_time	= 1.0
var move_away_timer:float = 0.0

enum STATES {STATE_IDLE, STATE_CHASE, STATE_RUN, STATE_MOVE_AWAY}

var state:int		= STATES.STATE_CHASE
var has_loot:bool	= false
var looted:bool		= false

var target:Node2D	= null
var players:Array = []

func _ready():
	state = STATES.STATE_CHASE

func grab_loot():
	has_loot = true
	looted = true
	state = STATES.STATE_RUN
	target = globals.camera

func _on_player_scan_body_entered(body:KinematicBody2D):
	if body.is_in_group("player"):
		players.append(body as Node2D)
		if looted == false:
			move_away_timer = move_away_time
			state = STATES.STATE_MOVE_AWAY
		
func _on_player_scan_body_exited(body:KinematicBody2D):
	if body.is_in_group("player"):
		players.erase(body)

func _on_critical_distance_body_entered(body:KinematicBody2D):
	if body.is_in_group("player"):
		state = STATES.STATE_RUN
		drop_loot()

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
	
func drop_loot():
	if has_loot:
		has_loot = false
#		drop loot