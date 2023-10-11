extends KinematicBody2D

var velocity = Vector2.ZERO

var target = Vector2(271, 519)
onready var timer = $"../../../Timer"
onready var player = $".."

enum{
	FERROMANTE,
	PLAYER
}

var transition = PLAYER
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta):
	match transition:
		PLAYER:
			if global_position.distance_to(player.global_position)  <= 10:
				global_position = player.global_position
			else:
				velocity = velocity.move_toward(global_position.direction_to(player.global_position) * 500,
				 global_position.distance_to(player.global_position) * delta * 100)
			
		FERROMANTE:
			velocity = velocity.move_toward(global_position.direction_to(target) * 500, global_position.distance_to(target) * delta * 100)
			if global_position.distance_to(target)  <= 50:
				velocity = Vector2.ZERO

	velocity = move_and_slide(velocity)
	

func _on_Ferromante_segunda_fase():
	transition = FERROMANTE
	timer.start(3)
	

func _on_Timer_timeout():
	transition = PLAYER
