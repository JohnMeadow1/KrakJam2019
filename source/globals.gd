extends Node


var wheel:Node = null
var cart:Node2D = null
var cart_node:Node = null
var players_position:Node2D = null
var camera:Camera2D = null

var players:Array = []

var active_players:float = 0.0

func _ready():
	wheel = null
	cart = null
	cart_node = null
	players_position = null
	camera = null
	players = []