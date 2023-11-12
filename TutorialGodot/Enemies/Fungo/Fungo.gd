extends KinematicBody2D

var vida
var cooldown
var agarraTempo
var target
var nextAttack

var velocity = Vector2.ZERO
var knockback =Vector2.ZERO

export var MAX_SPEED = 140
export var ACCELERATION = 140
export var FRICTION = 200

#se trocar de cenario tem q atualizar essa variavel manualmente
onready var player = $"../../../Player"
onready var wanderController = $WanderController
onready var sprite = $Sprite
onready var stats = $Stats
onready var hurtbox = $HurtBox

var state = IDLE
enum{
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
	LAUNCH
}

func _process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	match state:
		IDLE:#so fica parado
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if wanderController.get_time_left() == 0:
				update_wander()
			if Input.is_action_just_pressed("Abrir_Inv"):
				state = CHASE
		
		WANDER:#é apenas o modo wander do morcego, nada demais
			if wanderController.get_time_left() == 0:
				update_wander()#decide se fica parado ou n
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= 4:
				update_wander()#decide se fica parado ou n
			if Input.is_action_just_pressed("Abrir_Inv"):
				state = CHASE
			
		CHASE:
			
			sprite.texture = load("res://Enemies/Fungo/FungoCombate.png")
			target = player.global_position - global_position
			chase_state(delta)
		ATTACK:
			#Imagem: A-Train balofo
			sprite.texture = load("res://Enemies/Fungo/FunguAttack.jpg")
			attack_state(delta)
		LAUNCH:
			#Imagem: cachorro quente
			sprite.texture = load("res://Enemies/Fungo/FugusLaunch.jpg")
			launch_state(delta)
	velocity = move_and_slide(velocity)



func chase_state(delta):
	#Esse bicho sempre vai saber onde está o player
	#corre em direção ao player e quando chegar a uma certa distancia
	var direction = global_position.direction_to(player.global_position)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	
	# 1 = ele se joga // 2 = ele bate
	if nextAttack == 1:
		var distance = global_position.distance_to(player.global_position)
		#se o ele estiver da distancia certa ele se joga
		#se não, ele bate
		if distance <= 80 && distance >= 4:
			#se joga
			state = LAUNCH
		else:
			#bate
			nextAttack = 2
	elif global_position.distance_to(player.global_position) <= 4:
		#se estiver perto o suficiente le bate
		state = ATTACK

func attack_state(delta):
	#so pra eu saber q ele ta atacando
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * 10 * delta)
	if velocity == Vector2.ZERO:
		#ja define o proximo ataque
		nextAttack = randi()%2+1
		state = CHASE

func launch_state(delta):
	#so pra ver se ta tudo certo
	velocity = velocity.move_toward(target * MAX_SPEED, ACCELERATION * 2 * delta)
	if global_position.distance_to(player.global_position) >= 100:
		#define o proximo ataque
		nextAttack = randi()%2+1
		state = CHASE

#vai ate o ponto do wanderControl
func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

#decide se fica parado ou n
func update_wander():
	var random = randi()%2+1
	if random == 2:
		state = IDLE
	else:
		state = WANDER
	wanderController.start_wander_timer(rand_range(1,3))


func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	if stats.health <= 0:
		queue_free()
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
