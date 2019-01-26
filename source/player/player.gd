extends KinematicBody2D

const MOVE_SPEED  = 1000
const WALK_HEIGHT  = 5
const STUN_TIME   = 1

export(int) var PLAYER_NUM:int = 1
export var player_enabled:bool = false
var PLAYER_CONTROLS:int = 0

enum STATE {STATE_IDLE, STATE_WALK, STATE_FIGHT, STATE_STUN}
var state:int = STATE.STATE_IDLE

var move:Vector2       = Vector2()
var walk_cycle:float   = 0
var timer:float        = 5

var carry_item_handle:Node = null
var originPosition:Vector2 = Vector2()

var held_item:Node = null

func _ready():
	PLAYER_CONTROLS  = PLAYER_NUM
	self.state       = STATE.STATE_IDLE
	originPosition   = self.position
	
func _physics_process(delta):
	if timer > 0:
		timer -= delta
#	if !$pickup_area/Shape2D.disabled :
#		$pickup_area/Shape2D.disabled = true
	if held_item:
		held_item.position = lerp(held_item.position,$pivot/held_item.global_position, 0.2)
		if Input.is_action_just_pressed("action_p" + str(PLAYER_CONTROLS)):
			held_item.drop()
			held_item = null
	if player_enabled && Input.is_action_just_pressed("action_p" + str(PLAYER_CONTROLS)):
		var pick_up = false
		pickup_loot()

#		$pickup_area/Shape2D.disabled = false
		
#		if pick_up:
#			get_node("pick_up/Pick_up_" + str( randi() % 4 + 1) ).play()
#		else:
#			get_node("stab/stab_" + str( randi() % 4 + 1) ).play()
#			$AnimationPlayer.play("swing")
#			for body in get_tree().get_nodes_in_group("players"):
#				if body != self && body.position.distance_to(self.position) < 3:
#					var direction = body.position - self.position
#			for body in get_tree().get_nodes_in_group("sage"):
#				if body.position.distance_to(self.position) < 4:
#					body.checkWin(self)

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

	$pivot.position.y =  -sin( walk_cycle ) * WALK_HEIGHT
	$shade.modulate.a =  0.8 + $pivot.position.y * 0.1
	$shade.scale.x =  1.2 - $pivot.position.y * 0.1
	$shade.scale.y =  $shade.scale.x *0.5

	move = move_and_slide(move)
	move *= 0.90

func pickup_loot():
	var loot = $pickup_area.get_overlapping_areas()
	if loot.size()>0:
		loot[0].grab(50)
		held_item = loot[0]

func handle_input(offset):
	var player_moved = false
	if Input.is_action_pressed("move_up_p" + str(PLAYER_CONTROLS)):
		move.y      -= offset
		player_moved = true

	if Input.is_action_pressed("move_down_p" + str(PLAYER_CONTROLS)):
		move.y      += offset
		player_moved = true
	
	if Input.is_action_pressed("move_left_p" + str(PLAYER_CONTROLS)):
		move.x      -= offset
		player_moved = true

	if Input.is_action_pressed("move_right_p" + str(PLAYER_CONTROLS)):
		move.x      += offset
		player_moved = true

	return player_moved

func _loot_area_entered(area):
	print(area)
	pass # Replace with function body.


func _loot_area_exited(area):
	print(area)
	pass # Replace with function body.
