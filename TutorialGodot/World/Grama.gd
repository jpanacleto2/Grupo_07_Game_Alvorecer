extends Node2D

func create_grass_effect():
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	var grassEffect = GrassEffect.instance()
	#mudei pro efeito ser filho da camada de Ysort pra ela pode se encaixar no YSort e ficar bonito
	#eu n sei pq ta $"../.." kkkkkkkkkkkkkkkkkkkkkkkkkk
	#eu so cliquei e arrastei o conjunto de Ysort la na esquerda e deu esse nome, mas deu certo ent fds
	var world = $"../.."
	#o antigo era esse, caso queiram voltar:
	##var world = get_tree().current_scene
	world.add_child(grassEffect)
	grassEffect.global_position = global_position
		


func _on_HurtBox_area_entered(area):
	create_grass_effect()
	queue_free()
