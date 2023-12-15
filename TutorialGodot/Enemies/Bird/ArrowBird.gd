extends KinematicBody2D

const INITIAL_SPEED = 4500
const ACCELERATION = 500

#onready var ferromante = get_node("/root/World/YSort/Inimigos/Ferromante") #$"../Ferromante" 
onready var playerNode =  get_tree().current_scene.Player
onready var timer = $LifeTime
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var direction_calculated = false

	
func _ready():
	timer.start(3) # Tempo de desaparecimento dos pássaros
	#global_position = playerNode.global_position - Vector2(rand_range(25, 15), rand_range(25,15))
	
func _physics_process(delta):
	# Eu quero pegar a posição do jogador apenas uma vez, pois se eu pegar mais vezes,
	# o inimigo vai seguir o jogador, ao invés de se atirar a uma posição
	if !direction_calculated and playerNode != null:
		var player_position = playerNode.global_position
		
		# Definindo o raio de aparecimento dos pássaros
		var raio = 150
		var angulo = randf() * 2 * PI
		var posicao_aleatoria = player_position + Vector2(raio * cos(angulo), raio * sin(angulo))
		
		# Coloca o pássaro numa posição ao redor do jogador
		position = posicao_aleatoria 
		
		# Define a direção que o pássaro deve se mover (nesse caso em direção ao jogador)
		direction = (player_position - global_position).normalized() * INITIAL_SPEED
		
		direction_calculated = true
	
	velocity = velocity.move_toward(direction, delta * ACCELERATION)
	move_and_slide(velocity)


func _on_Timer_timeout():
	#ferromante.current_iteration -= 1
	queue_free()
