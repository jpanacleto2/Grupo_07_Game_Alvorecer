extends Popup

var slot = "" #qual dos slots do inventario é selecionda: Inv1 ou Inv2 etc
var origin = "" #isso aqui n importa mt n
onready var Equip = $Equipar
onready var Desc = $Descartar
onready var Usar = $Usar
var podeClicar = true#acho q isso aqui pode deletar, preguiça de testar

func _ready():
	#verifica se o item pode ser equipado ou usado
	var item = PlayerData.inv_data[slot]["Item"]
	if GameData.item_data[str(item)]["Equipar"] == 0:#muda o cursor dependendo se ele pode equipar
		Equip.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	else:
		Usar.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN



