extends TextureRect

var slot = "" #slot do inventario ao qual o item equipado pertence
var id = 0
var ison = false
onready var inventario = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
onready var quadradinho = get_parent().get_parent().get_parent()
onready var main = get_tree().current_scene

#verifica se é clicado
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			slot = get_parent().slot
			#pega o id do item no arquivo JSON
			id = str(PlayerData.inv_data[slot]["Item"])
			#verifica se o item pode realmente ser equipado
			if GameData.item_data[id]["Equipar"] == 1:
				#verifica se o item é uma armadura ou uma arma
				if GameData.item_data[id]["Category"] == "Weapon":
					#chama o metodo de equipar do inventario 
					#para desequipar o item anteriormente equipado
					inventario.equipar(id, 1)
					
					#aplica os efeitos da arma
					main.arma = GameData.item_data[id]["Attack"]
					#atualiza as imagens do inventario para não precisar fechar e abrir
					inventario.atualiza()
					
				else: #se for armadura
					inventario.equipar(id, 0)
					main.armadura = GameData.item_data[id]["Defense"]
					inventario.atualiza()
				
				
			get_parent().queue_free()
	
