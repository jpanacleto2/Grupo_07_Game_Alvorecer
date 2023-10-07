extends KinematicBody2D

onready var Stats = $Stats
var knockback = Vector2.ZERO


enum{
	IDLE,
	CHASE,
	WANDER
}

export var ACCELERATION = 200
export var MAX_SPEED = 350
export var FRICTION = 300



onready var state = WANDER
onready var velocity = Vector2.ZERO
onready var playerPos = $PlayerDetection
onready var softCollision = $SoftCollision
onready var sprite = $Sprite
onready var wander = $Wanderer

var main = preload("res://Player/Player.tscn")
var MopaEffect = preload("res://Effects/Hit.tscn")
var GanoEffect = preload("res://Effects/Death.tscn")
var look_vector


func _physics_process(delta):
	match state:
		IDLE:
			seek_player()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if wander.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wander.start_wander_timer(rand_range(1, 3))
		WANDER:
			seek_player()
			if wander.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wander.start_wander_timer(rand_range(1, 3))
			
			var direction = global_position.direction_to(wander.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED / 2, ACCELERATION * delta / 2)
			
			if global_position.distance_to(wander.target_position) <= 1:
				state = pick_random_state([IDLE, WANDER])
				wander.start_wander_timer(rand_range(1, 3))
		CHASE:
			var player = playerPos.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED/1.5, ACCELERATION * delta)
				pass
			else:
				state = IDLE
	
	if(velocity.x != 0):
		sprite.flip_h = velocity.x < 0
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

func seek_player():
	if playerPos.can_see_player():
		state = CHASE

func _on_Area2D_area_entered(area):
	knockback = area.knockBack_vector * 150
	Stats.health -= 1
	if Stats.health <= 0:
		deathEffect()
		queue_free()
	else:
		hitEffect()
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func deathEffect():
	var ganoEffect = GanoEffect.instance()
	get_parent().add_child(ganoEffect)
	ganoEffect.global_position = global_position
	
func hitEffect(): 
	var main = get_tree().current_scene
	var mopaEffect = MopaEffect.instance()
	main.add_child(mopaEffect)
	mopaEffect.global_position = global_position
	






