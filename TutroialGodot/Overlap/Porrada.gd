extends KinematicBody2D


onready var animationTree  = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
var dir
onready var parent = get_parent().get_parent().get_parent()

func _ready():
	animationTree.active = true
	print(global_position)

func _process(delta):
	animationTree.set("parameters/Bate/blend_position",Vector2(1, 0))
	
	pass
	
func set_direction(direction):
	#animationState.travel("Bate")
	dir = direction
	
func some():
	queue_free()

