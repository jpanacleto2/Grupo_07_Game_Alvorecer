extends Node2D


onready var player = $YSort/Player
onready var fade_animation = $YSort/Player/CanvasLayer/FadeAnimation


func _ready():
	fade_animation.play("fade_out")

# Quando o jogador entrar na caverna, vai tocar a animação de fade-in
func _on_BuracoCaverna_body_entered(body):
	if body == player:
		fade_animation.play("fade_in")
	
# Assim que a animação acabar, ou seja, assim que a tela ficar toda preta, ele vai trocar de cena
func _on_FadeAnimation_animation_finished(anim_name):
	if anim_name == "fade_in":
		print("OK")
		get_tree().change_scene("res://Caverna.tscn")
