extends Node2D

const MusicaAmbiente = preload("res://Music and Sounds/Musica/Floresta/MusicaTheStrokes.tscn")
const MusicaMorte = preload("res://Music and Sounds/Musica/Morte/StairWayToHeaven.tscn")
var tocando = false
var musica

var armadura = 0
var arma = 0
var equipado = false
var Check = Vector2(0,0)

onready var fade_animation = $YSort/Player/CanvasLayer/FadeAnimation

onready var Ferromante
onready var Player
onready var Grey


func _process(delta):
	if !tocando:
		musica = MusicaAmbiente.instance()
		add_child(musica)
		tocando = true


			

func stopMusic():
	musica.queue_free()
	musica = MusicaMorte.instance()
	add_child(musica)





func _ready():
	fade_animation.play("fade_out")

# Quando o jogador entrar na caverna, vai tocar a animação de fade-in
func _on_BuracoCaverna_body_entered(body):
	if body == Player:
		var STOP
		yield(get_tree().create_timer(0.2), "timeout")
		Player.velocity = Vector2.ZERO
		Player.state = STOP
		fade_animation.play("fade_in")
		
	
# Assim que a animação acabar, ou seja, assim que a tela ficar toda preta, ele vai trocar de cena
func _on_FadeAnimation_animation_finished(anim_name):
	if anim_name == "fade_in":
		print("OK")
		get_tree().change_scene("res://Cenarios/Caverna.tscn")
