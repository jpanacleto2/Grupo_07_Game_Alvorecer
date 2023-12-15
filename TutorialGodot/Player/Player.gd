extends KinematicBody2D

signal comeu_cogumelo


const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
const DeathScreen = preload("res://CogumeloTela/TelaMorte.tscn")
var Morte = false
#const CogumeloTela = preload("res://CogumeloTela/GreyState.tscn")

# O export torna possível alterar o valor de variáveis pelo editor, sem precisar
# entrar no código e, sobretudo, enquanto o jogo ainda está em execução.

var ACCELERATION = 500
var MAX_SPEED = 80
var ROLL_SPEED = 120
var FRICTION = 500


enum {
	MOVE,
	ROLL,
	ATTACK,
	STOP
}

var state = MOVE
var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats
var inv_aberto = false
var greyII = false
var armadura = 0

#variável de acesso para animação de correr para os lados
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var swordHitbox = $HitBoxPivot/SwordHitbox
onready var animationState = animationTree.get("parameters/playback")
onready var hurtbox = $HurtBox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var fade_animation = $CanvasLayer/FadeAnimation

const inv = preload("res://Inventario/Inventario.tscn")

func _ready():
	#randomize()
	print (get_tree().current_scene)
	get_tree().current_scene.Player = self
	stats.connect("no_health", self, "dead")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
	#yield(get_tree().create_timer(1), "timeout")
	respawn()
	

	
#"main"
func _physics_process(delta):
	#atualiza a defesa e o ataque do jogador
	swordHitbox.damage = 1 + get_tree().current_scene.arma
	armadura = 0 + get_tree().current_scene.armadura
	
	
	# Código que se ativa assim que o jogador come o cogumelo (Letra "Q" pra ativar)
	if greyII:
		emit_signal("comeu_cogumelo")

	match state:
		MOVE:
			move_state(delta) 
		
		ROLL:
			roll_state(delta)
		
		ATTACK:
			attack_state(delta)
		
		STOP:
			velocity = Vector2.ZERO
	
	velocity = move_and_slide(velocity)
	
#	if Input.is_action_just_pressed("Abrir_Inv"):
#		if inv_aberto == false:
#			inv_aberto = true
#		else:
#			if get_node("/root/World/CanvasLayer/Inventario") != null:
#				get_node("/root/World/CanvasLayer/Inventario").free()
#			inv_aberto = false
	if Input.is_action_just_pressed("Abrir_Inv") && inv_aberto == false:
		inv_aberto = true
	elif Input.is_action_just_pressed("Abrir_Inv"):
		inv_aberto = false
		
	var main = get_tree().current_scene
	if inv_aberto == false && main.get_node("/CanvasLayer/Inventario") != null:
		main.get_node("CanvasLayer/Inventario").free()
	elif inv_aberto == true && main.get_node("CanvasLayer/Inventario") == null: 
		var inventario = inv.instance()
		var canvas = $"../../CanvasLayer"
		canvas.add_child(inventario)
		inv_aberto = true
	

func move_state(delta): 
	
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# Condicional que detecta se o jogador está pressionando as teclas para se mover
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		# Quando o jogador não estiver pressionando as teclas, ele irá desacelerar
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	#move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("Attack"):
		state = ATTACK
	
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	#move()

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
#func move():
	#velocity = move_and_slide(velocity)
	
func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finished():
	state = MOVE

func respawn():
	animationTree.set("parameters/Respawn/blend_position", input_vector)
	animationState.travel("Respawn")
	stats.health = stats.max_health

func dead():
	get_tree().current_scene.stopMusic()
	get_tree().current_scene.armadura = 0
	get_tree().current_scene.arma = 0
	get_tree().current_scene.equipado = false
	animationTree.set("parameters/Death/blend_position", input_vector)
	animationState.travel("Death")
	state = STOP

func dead_screen():
	if Morte == false:
		var main = $"../../CanvasLayer"
		var deathInstance = DeathScreen.instance()
		main.add_child(deathInstance)
		Morte = true

func _on_HurtBox_area_entered(area):
	var dano = area.damage - armadura
	if dano < 0:
		dano = 0
	stats.health  -= dano
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)


func _on_HurtBox_invincibility_started():
	blinkAnimationPlayer.play("start")


func _on_HurtBox_invincibility_ended():
	blinkAnimationPlayer.play("stop")

# Função que detecta se o jogador está dentro da parede
func _on_walls_listener_body_entered(body):
	if body.is_in_group("paredes"):
		fade_animation.play("fade_in")

func _on_FadeAnimation_animation_finished(anim_name):
	if anim_name == "fade_in":
		
		# Se o jogador se prender dentro da parede, ele é penalizado retornando
		# ao início
		global_position = Vector2(0, 0)
		fade_animation.play("fade_out")
