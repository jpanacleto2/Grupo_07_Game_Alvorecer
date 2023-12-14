extends Node2D

const MusicaAmbiente = preload("res://Music and Sounds/Musica/Caverna/EnjoyTheSilence.tscn")
const MusicaMorte = preload("res://Music and Sounds/Musica/Morte/StairWayToHeaven.tscn")
var tocando = false
var musica

var numWolf = 0
var wolfs = Array()

var armadura = 0
var arma = 0
var equipado = false
var Check = Vector2(0,0)

onready var Ferromante
onready var Player
onready var Grey

#onready var player = $YSort/Player
onready var fade_animation = $YSort/Player/CanvasLayer/FadeAnimation
onready var paredeFalsa = $ParedeFalsa
onready var timer = $CogumeloTimer

func _ready():
	fade_animation.play("fade_out")
	Player.connect("comeu_cogumelo", self, "sumirParedes")
	
# Função que tira a colisão da parede falsa
func sumirParedes():
	paredeFalsa.collision_layer = 0
	paredeFalsa.collision_mask = 0
	paredeFalsa.visible = false
	timer.start(2)
	
func _process(delta):
	if !tocando:
		musica = MusicaAmbiente.instance()
		add_child(musica)
		tocando = true

func stopMusic():
	musica.queue_free()
	musica = MusicaMorte.instance()
	add_child(musica)


# Função que retorna a colisão da parede falsa
func _on_CogumeloTimer_timeout():
	paredeFalsa.collision_layer = 1
	paredeFalsa.collision_mask = 1
	paredeFalsa.visible = true
