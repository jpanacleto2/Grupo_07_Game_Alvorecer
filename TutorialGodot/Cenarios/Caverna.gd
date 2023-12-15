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
onready var Grey
onready var Player

onready var fade_animation = $YSort/Player/CanvasLayer/FadeAnimation
onready var paredeFalsa = $YSort/ParedeFalsa
onready var timer = $CogumeloTimer

func _ready():
	fade_animation.play("fade_out")
	Player.connect("comeu_cogumelo", self, "sumirParedes")
	
# Função que tira a colisão da parede falsa
func sumirParedes():
	paredeFalsa.collision_layer = 0
	paredeFalsa.collision_mask = 0
	paredeFalsa.visible = false
	timer.start(1)
	
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


func _on_Passagem_Boss_body_entered(body):
	if body == Player:
		var STOP
		yield(get_tree().create_timer(0.2), "timeout")
		Player.velocity = Vector2.ZERO
		Player.state = STOP
		#fade_animation.play("fade_in")
		get_tree().change_scene("res://Cenarios/Sala Boss.tscn")


func _on_FadeAnimation_animation_finished(anim_name):
	if anim_name == "fade_in":
		get_tree().change_scene("res://Cenarios/Sala Boss.tscn")
