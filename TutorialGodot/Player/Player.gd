extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

#velocidade padrao
var velocity = Vector2.ZERO

#"main"
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# Condicional que detecta se o jogador está pressionando as teclas para se mover
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		# Quando o jogador não estiver pressionando as teclas, ele irá desacelerar
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	
	velocity = move_and_slide(velocity)


