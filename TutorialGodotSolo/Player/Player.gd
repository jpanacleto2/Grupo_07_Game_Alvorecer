extends KinematicBody2D


#velocidade padrao
var velocity = Vector2.ZERO
var roll_velocity = Vector2.DOWN
var state = MOVE
var stats = PlayerStats
var hitSlide = Vector2.ZERO

onready var hit = $Hurtbox
onready var knockBack= $Position2D/sword
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

enum{
	MOVE,
	ROLL,
	ATTACK
}

func _ready():
	animationTree.active = true
	stats.connect("no_health", self, "queue_free")
	
#"main"
func _process(delta):
	match state:
		MOVE:
			movement(delta)
		ROLL:
			rollament()
		ATTACK:
			attackment(delta)
	
	

func movement(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		knockBack.knockBack_vector = input_vector
		roll_velocity = input_vector
		animationTree.set("parameters/Idle/blend_position", velocity)
		animationTree.set("parameters/Run/blend_position", velocity)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Rolar/blend_position", input_vector)
		animationState.travel("Run")
		velocity =  velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		hitSlide = velocity
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		hitSlide = velocity
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("Attack"):
		state = ATTACK
	if Input.is_action_just_pressed("Roll"):
		state = ROLL

func attackment(delta):
	velocity = hitSlide
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta/2)
	hitSlide = velocity
	velocity = move_and_slide(velocity)
	animationState.travel("Attack")

func rollament():
	hit.start_invicibility(0.75)
	animationState.travel("Rolar")
	velocity =  roll_velocity * 90
	velocity = move_and_slide(velocity)
	

func animFinish():
	state = MOVE


func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	print(hit.monitoring)
	hit.create_hit_effect()
	hit.start_invicibility(0.75)
	
		
