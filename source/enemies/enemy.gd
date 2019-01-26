extends KinematicBody2D
class_name Enemy

enum STATES {STATE_IDLE, STATE_CHASE, STATE_RUN}

var state:int		= STATES.STATE_CHASE
var has_loot:bool	= false

var target:Node2D	= null

func _ready():
	state = STATES.STATE_CHASE

func grab_loot():
	has_loot = true
	state = STATES.STATE_RUN
	target = globals.camera
