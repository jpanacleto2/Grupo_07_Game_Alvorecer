extends KinematicBody2D

const MAX_SPEED = 200
const ACCELERATION = 300
const FRICTION = 1000

const HitEffect = preload ("res://HitEffect.tscn")
const bird_scene = preload("res://Enemies/Bird/ArrowBird.tscn")
var current_iteration = 0
const wolf_scene = preload ("res://Enemies/Lobo/Wolf.tscn")
var contagem_lobos = 0
export var limite_lobos = 2

onready var playerPos = $PlayerDetection
onready var ArrowBirdTimer = $ArrowBirdTimer
onready var animationTree = $AnimationTree
onready var hitbox = $Position2D/HitBox
onready var timer = $Timer
onready var stats = $Stats
onready var animationState = animationTree.get("parameters/playback")
onready var state = IDLE
#se trocar o cenario tem q atualizar aqui
onready var player = get_tree().current_scene.Player

onready var teleporte = Vector2.ZERO
var recebeu_dano = false
var costas = Vector2.ZERO
var segundaFase = 1
var velocity = Vector2.ZERO #movimentação
var playerLoc = Vector2.ZERO #localização do player para a esquiva
var on_cooldown = false #cooldown
var attackID = 0 #numero usado para randomizar o proximo ataque
var invocaBird = true
var invocaLobo = true

signal segunda_fase

enum{
	IDLE, 
	CHASE,
	ATTACK,
	COMBAT,
	Intro2,
	DODGE
}

func _ready():
	get_tree().current_scene.Ferromante = self
	animationTree.active = true
	if segundaFase == 2:
		state = Intro2
	


func _physics_process(delta):
	if is_instance_valid(player):
		match state:
			IDLE:
				#Mantém o boss parado enquanto procura o jogador
				seek_player()
			CHASE:
				animationState.travel("Walk")
				animationTree.set("parameters/Walk/blend_position", velocity)
				#Acha o jogador e ataca ele
				chase_state(delta) #linha63
			ATTACK: 
				#Ativa o moveset
				
				match attackID:
					1:
						#ataque pesado
						attack_state1(delta)
						pass
					2:
						#aqui fica ataque rapido
						attack_state2(delta)
						
						pass
					3:
						#ataque ao teleportar
						attack_state3()
						pass
			COMBAT:
				#Faz o boss recuar caso não esteja pronto para atacar dnv
				attack_state4()
				combat_state(delta)
			DODGE:
				#Faz o boss esquivar
				dodge_state(delta)
			Intro2:
				#Introdução para segunda fase
				animationState.travel("Palmas")
				#animationTree.set("parameters/Walk/blend_position", velocity)
			
		velocity = move_and_slide(velocity)
		
#		if global_position.distance_to(player.global_position) >= 40 && Input.is_action_just_pressed("Attack"):
#			if randi()%2+1 == 1:
#				desvio_e_te_mato()
		if Input.is_action_just_pressed("Attack") && state != IDLE:
			yield(get_tree().create_timer(0.2), "timeout")
			if !recebeu_dano && randi()%4+1 == 1:
				desvio_e_te_mato()
		


func attack_state1(delta):
	#deixa as coordenadas prontas para o DODGE STATE
	playerLoc = player.global_position
	animationTree.set("parameters/Roll/blend_position", playerLoc)
	
	
	#Executa o ataque
	animationState.travel("Attack")
	
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	start_cooldown(rand_range(1, 3)/segundaFase)
	#Dodge STATE chamado ao terminar a animação


func attack_state2(delta):
	#deixa as coordenadas prontas para o DODGE STATE
	playerLoc = player.global_position
	animationTree.set("parameters/Roll/blend_position", playerLoc)
	
	
	#Executa o ataque
	animationState.travel("AttackRapido")
	velocity = global_position.direction_to(playerLoc) * 40
	start_cooldown(rand_range(1, 3)/segundaFase)
	#Dodge STATE chamado ao terminar a animação

func attack_state3():
	animationState.travel("AttackTeleporte")
	velocity = Vector2.ZERO
	
func attack_state4():
	
	if contagem_lobos < limite_lobos && invocaLobo:
		invocaLobo = false
		var wolf = wolf_scene.instance()
		get_parent().add_child(wolf)
		wolf.global_position = global_position
		wolf.connect("enemy_killed", self, "wolf_count_handler")
		contagem_lobos += 1
		#wolf.connect("enemy_killed", self, "wolf_killed_handler")
		
	
	if invocaBird:
		# Summonando os pássaros
		var bird = bird_scene.instance()
		#bird.global_position = player.global_position - Vector2(rand_range(25, 15), rand_range(25,15))
		get_parent().add_child(bird)
		invocaBird = false
		ArrowBirdTimer.start(1) # Tempo de espera pros pássaros aparecerem
		
#	else:
#		current_iteration = 0
#		start_cooldown(rand_range(1, 3))
#		anim_finish()
		
	
func desvio_e_te_mato():
	costas = player.roll_vector
	var alvo
	match costas:
		Vector2(1,0):
			global_position = player.global_position + Vector2(-20, 0)
			attackID = 3
			alvo = global_position.direction_to(player.global_position)
			animationTree.set("parameters/AttackTeleporte/blend_position", alvo)
			state = ATTACK
			#print("direita")
		Vector2(0,1):
			teleporte = player.global_position + Vector2(0, -20)
			global_position = teleporte
			attackID = 3
			alvo = global_position.direction_to(player.global_position)
			animationTree.set("parameters/AttackTeleporte/blend_position", alvo)
			state = ATTACK
			#print("baixo")
		Vector2(-1,0):
			teleporte = player.global_position + Vector2(20, 0)
			global_position = teleporte
			attackID = 3
			alvo = global_position.direction_to(player.global_position)
			animationTree.set("parameters/AttackTeleporte/blend_position", alvo)
			state = ATTACK
			#print("esquerda")
		Vector2(0,-1):
			teleporte = player.global_position + Vector2(0, 20)
			global_position = teleporte
			attackID = 3
			alvo = global_position.direction_to(player.global_position)
			animationTree.set("parameters/AttackTeleporte/blend_position", alvo)
			state = ATTACK
			#print("cima")
	pass


func chase_state(delta):
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
			
		
			attackID = randi()%2+1 #pega um numero aleatorio entre 2 e 1
			
			state = ATTACK
		#Se ele estiver apenas perto ele para de avançar e não ataca
		elif global_position.distance_to(player.global_position) <= 30:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			state = CHASE
	else:#se o jogador sair do seu range ele volta pro IDLE
		state = IDLE


func combat_state(delta):
	animationTree.set("parameters/Walk/blend_position", player.global_position)
	animationState.travel("Walk")
	
	#Se ele estiver pronto para bater e o jogador estiver presente, 
	#ele volta para o CHASE que vai para o ATTACK
	if !on_cooldown && player != null:
			state = CHASE
	#Se ele ainda não está pronto para bater ele vai andar na direção contraria do jogador
	elif timer.time_left > 0:
		velocity = velocity.move_toward(global_position.direction_to(player.global_position) * 50, 50 * -delta)
		#se ele se afastar demais ele para de se afastar
		if global_position.distance_to(player.global_position) >= 55:
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
	hitbox.active = false

#toca no fim da esquiva
func anim_finish_dodge():
	#fazendo assim, a velocidade do dodge e do combat não sao afetador
	#é parecido com "velocity.move_toward(Vector2.ZERO, 50)", so que instantaneo
	velocity = Vector2.ZERO 
	state = COMBAT

func anim_finish_morte():
	queue_free()

var loop = 0
func intro2():
	if loop > 1:
		anim_finish_dodge()
	loop += 1

func seek_player():
	if playerPos.can_see_player():
		animationState.travel("Levantar")


func _on_Timer_timeout():
	on_cooldown = false
	
func start_cooldown(time):
	on_cooldown = true
	timer.start(time)


func _on_Hurtbox_area_entered(area):
	recebeu_dano = true
	hitEffect()
	stats.set_health(stats.health - 1)


func _on_Stats_no_health():
	print(segundaFase)
	if segundaFase == 2:
		velocity = Vector2.ZERO
		state = null
		animationState.travel("Morte")
	else:
		emit_signal("segunda_fase")
		iniciar_segunda_fase()
		queue_free()

func hitEffect(): 
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position
	yield(get_tree().create_timer(0.5), "timeout")
	recebeu_dano = false

func slashEffect():
	var direction = global_position.direction_to(player.global_position)
	hitbox.set_slash_direction(direction)
	hitbox.SlashEffect()

func iniciar_segunda_fase():
	var main = get_node("/root/World/YSort/Inimigos")
	var Verdadeiro = load("res://Enemies/Bosses/Ferromante/Ferromante.tscn")
	var verdadeiro = Verdadeiro.instance()
	verdadeiro.segundaFase = 2
	main.add_child(verdadeiro)
	verdadeiro.global_position = Vector2(271, 519)
	verdadeiro.stats.set_health(stats.max_health/2)
	

func wolf_count_handler():
	#contagem_lobos -= 1
	#contagem_lobos -= 1
	pass

func _on_ArrowBirdTimer_timeout():
	# Condicional que impede a função attack_state4 de ser chamada infinitamente
	invocaBird = true
	invocaLobo = true
