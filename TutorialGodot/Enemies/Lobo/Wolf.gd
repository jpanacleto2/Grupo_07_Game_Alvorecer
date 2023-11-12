extends KinematicBody2D

signal enemy_killed

var Ferromante #= get_node("/root/World/YSort/Inimigos/Ferromante") 
onready var player = get_node("/root/World/YSort/Player")
onready var Stats = $Stats


export var ACCELERATION = 200
export var MAX_SPEED = 350
export var FRICTION = 300


onready var velocity = Vector2.ZERO
onready var playerPos = $PlayerDetection
onready var softCollision = $SoftCollision
onready var sprite = $Sprite
onready var wander = $Wanderer


var main = preload("res://Player/Player.tscn")
var HitEffect = preload("res://HitEffect.tscn")
var GanoEffect = preload("res://Effects/EnemyDeathEffect.tscn")
var knockback = Vector2.ZERO
var ID

func _ready():
	ID = get_tree().current_scene.numWolf
	get_tree().current_scene.numWolf += 1
	get_tree().current_scene.wolfs.append(self)


func _physics_process(delta):
	
	#var player = playerPos.player
	var direction
	if is_instance_valid(player):
		direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED/1.5, ACCELERATION * delta)
	
	if(velocity.x != 0):
		sprite.flip_h = velocity.x < 0
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)
	knockback = move_and_slide(knockback)
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	Ferromante = get_tree().current_scene.Ferromante
	
	



func deathEffect():
	var ganoEffect = GanoEffect.instance()
	get_parent().add_child(ganoEffect)
	ganoEffect.global_position = global_position
	
func hitEffect(): 
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position




func _on_HurtBox_area_entered(area):
	knockback = area.knockback_vector * 150
	Stats.health -= 1
	#print(Stats.health)
	if Stats.health <= 0:
		deathEffect()
		emit_signal("enemy_killed")
		if is_instance_valid(Ferromante):
			Ferromante.contagem_lobos -= 1
		#FerromanteNode.slashEffect()
		get_tree().current_scene.wolfs[ID] = null
		queue_free()
	else:
		hitEffect()



