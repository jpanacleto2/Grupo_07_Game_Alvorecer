extends Popup

var slot = "" #qual dos slots do inventario é selecionda: Inv1 ou Inv2 etc
var origin = "" #isso aqui n importa mt n
onready var Equip = $Equipar
onready var Desc = $Descartar
onready var Usar = $Usar
var podeClicar = true #acho q isso aqui pode deletar, preguiça de testar
var posSelect = 0

func _ready():
	#verifica se o item pode ser equipado ou usado
	var item = PlayerData.inv_data[slot]["Item"]
	if GameData.item_data[str(item)]["Equipar"] == 0:#muda o cursor dependendo se ele pode equipar
		Equip.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	else:
		Usar.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN

func _process(delta):
	#aqui verifica qual das opções ta selecionada pra ser usada
	if Input.is_action_just_pressed("Select"):
		match posSelect:
			1:
				get_node("Usar").funcao()
			2:
				get_node("Descartar").funcao()
			3:
				get_node("Equipar").funcao()
			
	
	#Cada um das opções equivale a um numero
	#1 = Usar // 2 = Descartar // 3 = Equipar
	if Input.is_action_just_pressed("Select_Down"):
		if posSelect + 1 < 4:
			posSelect += 1
		else:
			posSelect = 1
	if Input.is_action_just_pressed("Select_Up"):
		if posSelect - 1 > 0:
			posSelect -= 1
		else:
			posSelect = 3
	
	#Aqui o sprite muda para mostrar qual deles ta selecionado
	match posSelect:
			#A opção q é selecionada aparece um frame em volta dela que antes estava invisivel
			1:
				get_node("Usar/Select").visible = true
				get_node("Descartar/Select").visible = false
				get_node("Equipar/Select").visible = false
			2:
				get_node("Usar/Select").visible = false
				get_node("Descartar/Select").visible = true
				get_node("Equipar/Select").visible = false
			3:
				get_node("Usar/Select").visible = false
				get_node("Descartar/Select").visible = false
				get_node("Equipar/Select").visible = true


