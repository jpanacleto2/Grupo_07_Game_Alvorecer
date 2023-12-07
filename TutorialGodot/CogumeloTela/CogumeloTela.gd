extends Node2D


#onready var sprite = $Sprite
# var a = 2
# var b = "text"
var cresce = true


enum{
	ANIM
	ANIM2
}

var state = ANIM
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().current_scene.Grey = self
	scale = Vector2(0.26, 0.255)
	self_modulate.a = 0
	#(0.26, 0.25)


func _process(delta):
	match state:
		ANIM:
			if cresce:
				cresceAnim(0.0001)
		ANIM2:
			if cresce:
				cresceAnim(-0.0001)


func aparecer():
	#lentamente aumenta a opacidade da tela
	for i in 50:
		self_modulate.a += 0.02
		yield(get_tree().create_timer(0.04), "timeout")
	yield(get_tree().create_timer(10), "timeout")
	#depois de 10 segundos a tela some e seus efeitos tbm
	sumir()
	get_tree().current_scene.Player.greyII = false
		
func sumir():
	#faz a tela sumir pelo mesmo processo q faz ela aparecer
	for i in 50:
		self_modulate.a -= 0.02
		yield(get_tree().create_timer(0.04), "timeout")
	

func cresceAnim(num):
	#animação de quando a tela está ativa
	cresce = false #impede q o metodo seja chamada varias vezes fora da hora
	for i in 20:
		scale.x -= num
		scale.y -= num
		yield(get_tree().create_timer(0.04), "timeout")
	cresce = true #permite q o metodo seja chamado dnv
	if state == ANIM: #verifica se o proximo passo é aumentar ou diminuir
		state = ANIM2
	else:
		state = ANIM
	
	
