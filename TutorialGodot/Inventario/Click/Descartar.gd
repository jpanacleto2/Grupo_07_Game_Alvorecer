extends TextureRect

var slot = ""
var id = 0
var ison = false
onready var main = get_tree().current_scene
onready var inventario = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
onready var quadradinho = get_parent().get_parent().get_parent()
const item = preload("res://Inventario/Itens/Item.tscn")
#var template_inv_slot = preload("res://Inventario/InvSlot/InvSlot.tscn")
func _ready():
	print(quadradinho)
#onready var gridcontainer = $Background/M/GridContainer
	

#							main.Player.stats.health += 1
#			get_parent().get_parent().get_parent().get_parent().queue_free()
		##gridcontainer.add_child(inv_slot_new, true)
		
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			funcao()

func funcao():
	slot = get_parent().slot
	var item_instance = item.instance()
	var item = PlayerData.inv_data[slot]["Item"]
	item_instance.id = item
			
	if GameData.item_data[str(item)]["Equipado"] == true:
		if GameData.item_data[str(item)]["Category"] == "Weapon":
			main.arma = 0
		else:
			main.armadura = 0
	
	GameData.item_data[str(item)]["Equipado"] = false
	main.add_child(item_instance)
	item_instance.global_position = main.Player.global_position
	item_instance.expulso()
	PlayerData.inv_data[slot]["Item"] = null
	inventario.descartar(quadradinho)
	inventario.atualiza()
	#get_parent().get_parent().get_parent().get_parent().queue_free()
			
	get_parent().queue_free()
	
