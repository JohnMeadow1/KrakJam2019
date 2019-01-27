extends KinematicBody2D
class_name Player

const MOVE_SPEED  = 1000
const WALK_HEIGHT  = 5
const STUN_TIME   = 2

export(int) var PLAYER_NUM:int = 1
export var player_enabled:bool = false
var PLAYER_CONTROLS:int = 0

enum STATE {STATE_IDLE, STATE_WALK, STATE_FIGHT, STATE_STUN}
var state:int = STATE.STATE_IDLE

var move:Vector2		= Vector2()
var walk_cycle:float	= 0
var timer:float			= 5
var stun_timer:float	= 0

var originPosition:Vector2 = Vector2()
var can_drive = false
var is_driving = false
var held_item:Node = null

var enabled_timer:float = 0.0

func _ready():
	PLAYER_CONTROLS  = PLAYER_NUM
	self.state       = STATE.STATE_IDLE
	originPosition   = self.position
	
func _physics_process(delta):
	if timer > 0:
		timer -= delta
	enabled_timer = max(enabled_timer - delta*0.1, 0)

			
	if is_driving:
		position = globals.cart_node.position
		if Input.is_action_pressed("action_p" + str(PLAYER_CONTROLS)):
			if globals.cart_node.get_out():
				is_driving = false
				enable_coliders()
		var target_stering = handle_drive_input()
		globals.cart_node.target_stering = target_stering.y
		globals.cart_node.speed = target_stering.x
	elif can_drive && Input.is_action_pressed("action_p" + str(PLAYER_CONTROLS)):
		if globals.cart_node.get_in(PLAYER_CONTROLS):
			is_driving = true
			disable_coliders()
	
	if state == STATE.STATE_STUN && stun_timer > 0:
		stun_timer -= delta
	else:
		if held_item:
			held_item.position = lerp(held_item.position,$pivot/held_item.global_position, 0.2)
			if Input.is_action_just_pressed("action_p" + str(PLAYER_CONTROLS)):
				for area in $pivot/drop_area.get_overlapping_areas():
					if area.is_in_group("drop_point"):
						held_item.queue_free()
						if held_item.is_in_group("wheel"):
							area.get_parent().add_wheel()
						else:
							area.get_parent().add_loot()
						break
				held_item.drop()
				held_item = null
		elif player_enabled && Input.is_action_just_pressed("action_p" + str(PLAYER_CONTROLS)):
			pickup_loot()
			
	
		if player_enabled :
			$StunParticle.emitting = false
			
			var offset = MOVE_SPEED * delta
			var player_moved = handle_input(offset)
			
			if player_moved:
				enabled_timer = min(enabled_timer+delta, 1)
				if !$pivot/AnimationPlayer.is_playing():
					$pivot/AnimationPlayer.play("walk")
				self.state = STATE.STATE_WALK
				walk_cycle += 0.2
				if walk_cycle >= PI:
					walk_cycle -= PI
	#				get_node("steps/Steps_" + str( randi() % 10 + 1 ) ).play()
			elif self.state != STATE.STATE_IDLE:
				if !$pivot/AnimationPlayer.current_animation=="attack":
					$pivot/AnimationPlayer.play("idle")
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
func disable_coliders():
	$shade.visible = false
	$CollisionShape.disabled = true
	$pivot/player_sprite.visible = false
	$pickup_area/Shape2D.disabled = true
	$pivot/drop_area/Shape2D.disabled = true
func enable_coliders():
	$shade.visible = true
	$CollisionShape.disabled = false
	$pivot/player_sprite.visible = true
	$pickup_area/Shape2D.disabled = false
	$pivot/drop_area/Shape2D.disabled = false
func pickup_loot():
	var loot = $pickup_area.get_overlapping_areas()
	if loot.size() >0:
		for item in loot:
			if item.is_in_group("loot"):
				item.grab(50, self)
				held_item = item
				return
	else:
		$pivot/AnimationPlayer.play("attack")
		$atack_whosh.play()
		
func handle_drive_input():
	var target_stering = Vector2(20,0)
	if Input.is_action_pressed("move_up_p" + str(PLAYER_CONTROLS)):
		target_stering.y = -20

	if Input.is_action_pressed("move_down_p" + str(PLAYER_CONTROLS)):
		target_stering.y = 20
		
	if Input.is_action_pressed("move_left_p" + str(PLAYER_CONTROLS)):
		target_stering.x = 75

	if Input.is_action_pressed("move_right_p" + str(PLAYER_CONTROLS)):
		target_stering.x = 1
		
	return target_stering

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
		$pivot.scale.x = -1

	if Input.is_action_pressed("move_right_p" + str(PLAYER_CONTROLS)):
		move.x      += offset
		player_moved = true
		$pivot.scale.x = 1

	return player_moved

func stun():
	state = STATE.STATE_STUN
	stun_timer += STUN_TIME
	$StunParticle.emitting = true
	if held_item:
		held_item.drop()
		held_item = null
	$rock_hit.play()
