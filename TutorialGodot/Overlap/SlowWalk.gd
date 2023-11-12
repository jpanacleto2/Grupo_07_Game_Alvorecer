extends Area2D

var player = null

func can_see_player():
	return player != null



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SlowWalk_body_entered(body):
	player = body
	body.VELOCITY = body.VELOCITY / 2
	body.ACCELERATION = body.ACCELERATION / 2


func _on_SlowWalk_body_exited(body):
	player = body
	body.VELOCITY = body.VELOCITY * 2
	body.ACCELERATION = body.ACCELERATION * 2
