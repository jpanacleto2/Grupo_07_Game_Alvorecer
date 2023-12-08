extends Node2D

onready var player = $YSort/Player
onready var fade_animation = $YSort/Player/CanvasLayer/FadeAnimation
onready var paredeFalsa = $ParedeFalsa
onready var timer = $CogumeloTimer

func _ready():
	fade_animation.play("fade_out")
	player.connect("comeu_cogumelo", self, "sumirParedes")
	
# Função que tira a colisão da parede falsa
func sumirParedes():
	paredeFalsa.collision_layer = 0
	paredeFalsa.collision_mask = 0
	paredeFalsa.visible = false
	timer.start(5)

# Função que retorna a colisão da parede falsa
func _on_CogumeloTimer_timeout():
	paredeFalsa.collision_layer = 1
	paredeFalsa.collision_mask = 1
	paredeFalsa.visible = true
