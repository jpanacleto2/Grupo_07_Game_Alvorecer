extends KinematicBody2D

var vida
var cooldown = false
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
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var stats = $Stats
onready var hurtbox = $HurtBox
onready var timer = $Timer

var state = IDLE
enum{
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
	LAUNCH
}

func _ready():
	animationTree.active = true
	nextAttack = randi()%3+2

func _process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	if Input.is_action_just_pressed("roll"):
		state = CHASE
	print(nextAttack)
	match state:
		IDLE:#so fica parado
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if wanderController.get_time_left() == 0:
				update_wander()
			animationState.travel("Idle")
			animationTree.set("parameters/Idle/blend_position", velocity)
			
		
		WANDER:#é apenas o modo wander do morcego, nada demais
			animationState.travel("Walk")
			animationTree.set("parameters/Walk/blend_position", velocity)
			if wanderController.get_time_left() == 0:
				update_wander()#decide se fica parado ou n
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= 4:
				update_wander()#decide se fica parado ou n
		CHASE:
			animationState.travel("Walk")
			animationTree.set("parameters/Walk/blend_position", velocity)
			target = player.global_position - global_position
			chase_state(delta)
		ATTACK:
			animationState.travel("Atack")
			animationTree.set("parameters/Atack/blend_position", velocity)
			attack_state(delta)
			
		LAUNCH:
			#cachorro quente
			animationState.travel("Launch")
			animationTree.set("parameters/Launch/blend_position", target)
			launch_state(delta)
			
	velocity = move_and_slide(velocity)



func chase_state(delta):
	#Esse bicho sempre vai saber onde está o player
	#corre em direção ao player e quando chegar a uma certa distancia
	var direction = global_position.direction_to(player.global_position)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	
	# ele se joga //  ele bate
	if nextAttack > 1 && !cooldown:
		var distance = global_position.distance_to(player.global_position)
		if global_position.distance_to(player.global_position) <= 100:
			timer.start(4)
			state = LAUNCH
	elif nextAttack == 1 && !cooldown:
		#se estiver perto o suficiente le bate
		if global_position.distance_to(player.global_position) <= 10:
			timer.start(4)
			state = ATTACK

func attack_state(delta):
	#so pra eu saber q ele ta atacando
	cooldown = false
	#velocity = velocity.move_toward(Vector2.ZERO, FRICTION * 10 * delta)
	velocity = Vector2.ZERO

func launch_state(delta):
	#so pra ver se ta tudo certo
	cooldown = false
	velocity = velocity.move_toward(target * MAX_SPEED, ACCELERATION * 2 * delta)

#vai ate o ponto do wanderControl
func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

#decide se fica parado ou n
func update_wander():
	var random = randi()%3+1
	if random == 2:
		state = IDLE
	else:
		state = WANDER
	wanderController.start_wander_timer(rand_range(1,3))

func anim_finish():
	nextAttack = randi()%2+1
	state = CHASE

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	if stats.health <= 0:
		queue_free()
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)


func _on_Timer_timeout():
	cooldown = false
