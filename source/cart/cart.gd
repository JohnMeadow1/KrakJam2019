extends KinematicBody

export(float) var speed:float = 1.0

var move:Vector3       = Vector3.ZERO


func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	move = Vector3.ZERO
	move.x -= speed * delta
	translate(move)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier_screen_exited():
	print("wózek poza ekranem")
	pass
