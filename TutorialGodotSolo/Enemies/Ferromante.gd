extends KinematicBody2D

const MAX_SPEED = 200
const ACCELERATION = 300
const FRICTION = 1000
const wolf_scene = preload("res://Enemies/Wolf.tscn")
const bird_scene = preload("res://Enemies/ArrowBird.tscn")
const HitEffect = preload ("res://Effects/Hit.tscn")

onready var playerPos = $PlayerDetection
onready var animPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var timer = $Timer
onready var arrowBirdTimer = $ArrowBird_Timer
onready var stats = $Stats
onready var animationState = animationTree.get("parameters/playback")
onready var state = IDLE

var contagem_lobos = 0
var limite_lobos = 2
var limite_passaros = 5
var current_iteration = 0
var segundaFase = 1
var velocity = Vector2.ZERO #movimentação
var playerLoc = Vector2.ZERO #localização do player para a esquiva
var on_cooldown = false #cooldown
var attackID = 0 #numero usado para randomizar o proximo ataque

signal segunda_fase

enum{
	IDLE, 
	CHASE,
	ATTACK,
	COMBAT,
	DODGE
}

func _ready():
	animationTree.active = true
 
func _physics_process(delta):
	if playerPos.player != null:
		match state:
			IDLE:
				#Mantém o boss parado enquanto procura o jogador
				seek_player()
			CHASE:
				animationState.travel("Idle")
				animationTree.set("parameters/Idle/blend_position", velocity)
				#Acha o jogador e ataca ele
				chase_state(delta) #linha63
			ATTACK: 
				#Ativa o moveset
				match attackID:
					1:
						#ataque pesado
						attack_state1(delta)
					2:
						#aqui fica ataque rapido
						attack_state2(delta)
					3:
						# Summon dos mobs
						attack_state3()
			COMBAT:
				#Faz o boss recuar caso não esteja pronto para atacar dnv
				combat_state(delta)
			DODGE:
				#Faz o boss esquivar
				dodge_state(delta)
		velocity = move_and_slide(velocity)


func attack_state1(delta):
	#deixa as coordenadas prontas para o DODGE STATE
	playerLoc = playerPos.player.global_position
	animationTree.set("parameters/Roll/blend_position", playerLoc)
	
	#Executa o ataque
	animationState.travel("Attack")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	start_cooldown(rand_range(1, 3)/segundaFase)
	#Dodge STATE chamado ao terminar a animação


func attack_state2(delta):
	#deixa as coordenadas prontas para o DODGE STATE
	playerLoc = playerPos.player.global_position
	animationTree.set("parameters/Roll/blend_position", playerLoc)
	#Executa o ataque
	animationState.travel("AttackRapido")
	velocity = global_position.direction_to(playerLoc) * 40
	start_cooldown(rand_range(1, 3)/segundaFase)
	#Dodge STATE chamado ao terminar a animação

func attack_state3():
	
	if contagem_lobos < limite_lobos:
		var wolf = wolf_scene.instance()
		get_tree().get_root().get_node(".").add_child(wolf)
		
		wolf.connect("enemy_killed", self, "wolf_killed_handler")
		contagem_lobos += 1
	
	if current_iteration < limite_passaros:
		

		# Summonando os pássaros
		var bird = bird_scene.instance()
		get_tree().get_root().get_node(".").add_child(bird)
		
		current_iteration += 1
		arrowBirdTimer.start(0.3) # Tempo de espera pros pássaros aparecerem
		
	else:
		current_iteration = 0
		start_cooldown(rand_range(1, 3))
		anim_finish()
		
func chase_state(delta):
	var player = playerPos.player
	if player != null:
		#Acha o jogador e vai para cima dele
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		#Se ele ja estiver perto e pronto para atacar, ele ataca
		if global_position.distance_to(player.global_position) <= 30 && !on_cooldown:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			#velocity = Vector2.ZERO
			animationTree.set("parameters/Attack/blend_position", direction)
			animationTree.set("parameters/AttackRapido/blend_position", direction)
			attackID = 3 #randi()%3+1 #pega um numero aleatorio entre 3 e 1
			state = ATTACK
		#Se ele estiver apenas perto ele para de avançar e não ataca
		elif global_position.distance_to(player.global_position) <= 30:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			state = CHASE
	else:#se o jogador sair do seu range ele volta pro IDLE
		state = IDLE


func combat_state(delta):
	animationTree.set("parameters/Idle/blend_position", playerPos.global_position)
	animationState.travel("Idle")
	
	#Se ele estiver pronto para bater e o jogador estiver presente, ele volta para o CHASE que vai para o ATTACK
	if !on_cooldown && playerPos.can_see_player():
			state = CHASE
	#Se ele ainda não está pronto para bater ele vai andar na direção contraria do jogador
	elif timer.time_left > 0:
		velocity = velocity.move_toward(global_position.direction_to(playerPos.player.global_position) * 50, 50 * -delta)
		#se ele se afastar demais ele para de se afastar
		if global_position.distance_to(playerPos.player.global_position) >= 55:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	else:#se ele não encontar o jogador ele volta para o IDLE
		state = IDLE

func dodge_state(delta):
	
	animationState.travel("Roll")
	#playerLoc localisa o jogador durante o ataque
	var dodgeDirection = global_position.direction_to(playerLoc)
	dodgeDirection = dodgeDirection.normalized()
	velocity += dodgeDirection * -6
	#COMBAT chamado ao terminar animação

	
#toca no fim do ataque
func anim_finish():
	if randi()%2+1 == 1:
		velocity = Vector2.ZERO
		state = DODGE
	else:
		state = COMBAT

#toca no fim da esquiva
func anim_finish_dodge():
	#fazendo assim, a velocidade do dodge e do combat não sao afetador
	velocity = Vector2.ZERO #é parecido com "velocity.move_toward(Vector2.ZERO, 50)", so que instantaneo
	state = COMBAT

func seek_player():
	if playerPos.can_see_player():
		state = CHASE

func _on_Timer_timeout():
	on_cooldown = false
	
func start_cooldown(time):
	on_cooldown = true
	timer.start(time)


func _on_Hurtbox_area_entered(area):
	hitEffect()
	stats.set_health(stats.health - 1)


func _on_Stats_no_health():
	if segundaFase == 2:
		queue_free()
	else:
		emit_signal("segunda_fase")
		iniciar_segunda_fase()
		queue_free()

func hitEffect(): 
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position

func iniciar_segunda_fase():
	var main = $".."
	var Verdadeiro = load("res://Enemies/Ferromante.tscn")
	var verdadeiro = Verdadeiro.instance()
	main.add_child(verdadeiro)
	verdadeiro.global_position = Vector2(271, 519)
	verdadeiro.segundaFase = 2
	verdadeiro.stats.set_health(stats.max_health/2)

func wolf_killed_handler():
	contagem_lobos -= 1

func _on_ArrowBird_Timer_timeout():
	# Condicional que impede a função attack_state3 de ser chamada infinitamente
	if current_iteration < limite_passaros:
		attack_state3()
