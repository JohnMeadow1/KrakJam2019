extends Node2D

const TRACK_LENGTH = 100
var track = PoolVector2Array()
var track2 = PoolVector2Array()
var track_size   = PoolIntArray()
var tick:int = 0

func _physics_process(_delta):
	tick += 1
	tick %= 10
	if tick == 0:
		if( track.size() >= TRACK_LENGTH ):
			track.remove(0)
			track2.remove(0)
			track_size.remove(0)
		track.append(globals.wheel.global_position)
		track2.append(globals.wheel.global_position+Vector2(0,-10))
		if globals.cart_node.bump_velcocity == 0.0:
			track_size.append(2)
		else:
			track_size.append(0)
		update()

func _draw():
	for i in range(track.size() -1 ):
		draw_line(track[i], track[i+1], Color(0, 0, 0, 0.3), track_size[i])
		draw_line(track2[i], track2[i+1], Color(0, 0, 0, 0.3), track_size[i])
