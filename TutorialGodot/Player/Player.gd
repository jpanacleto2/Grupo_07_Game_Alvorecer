extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

#velocidade padrao
var velocity = Vector2.ZERO


#variável de acesso para animação de correr para os lados
onready var animationPlayer = $AnimationPlayer

	
#"main"
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# Condicional que detecta se o jogador está pressionando as teclas para se mover
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			animationPlayer.play("RunRight")
		elif input_vector.x < 0:
			animationPlayer.play("RunLeft")
		
		if input_vector.y > 0:
			animationPlayer.play("RunDown")
		elif input_vector.y < 0:
			animationPlayer.play("RunUp")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		# Quando o jogador não estiver pressionando as teclas, ele irá desacelerar
		animationPlayer.play("IdleRight")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	
	velocity = move_and_slide(velocity)


