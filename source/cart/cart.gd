extends KinematicBody2D

export(float) var speed:float = 10.0

var move:Vector2       = Vector2.ZERO


func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	move = Vector2.ZERO
	move.x -= speed * delta
	translate(move)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier_screen_exited():
	print("wózek poza ekranem")
	pass


func _on_Area2D_body_entered(body):
	var enemy:Enemy = body as Enemy
	
	if not enemy:
		return
		
	enemy.grab_loot()
