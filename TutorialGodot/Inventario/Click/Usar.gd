extends TextureRect

var slot = ""
var id = 0
var ison = false
onready var inventario = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
onready var quadradinho = get_parent().get_parent().get_parent()
onready var main = get_tree().current_scene



#							print("Cogumelo")
#							main.Player.stats.set_health(1)
#						"10006":
#							print("Pocaozinha de cura")
#							main.Player.stats.health += 1
#			get_parent().get_parent().get_parent().get_parent().queue_free()
		##gridcontainer.add_child(inv_slot_new, true)
		
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			#slot = get_parent().get_parent().get_parent().get_parent().slot
			slot = get_parent().slot
			#if PlayerData.inv_data[slot]["Item"] != null:
				#var item_name = GameData.item_data[str(PlayerData.inv_data[slot]["Item"])]["Name"]
			id = str(PlayerData.inv_data[slot]["Item"])
			print("FFFFF")
			if GameData.item_data[id]["Usar"] == 1:
				id = str(PlayerData.inv_data[slot]["Item"])
				#id = PlayerData.inv_data[slot]["Item"]
				match id:
					"10005":
						if main.Player.greyII == false:
							main.Grey.aparecer()
							main.Player.greyII = true
							
						print("GreyuII: " + str(main.Player.greyII))
					"10006":
						print("Pocaozinha de cura")
						inventario.descartar(quadradinho)
						main.Player.stats.health += 1
					"10008":
						print("Paozinho")
						main.Player.stats.health += 2
						inventario.descartar(quadradinho)
						main.Player.stats.health += 1
			#get_parent().get_parent().get_parent().get_parent().queue_free()
			get_parent().queue_free()
		#gridcontainer.add_child(inv_slot_new, true)
	
	

