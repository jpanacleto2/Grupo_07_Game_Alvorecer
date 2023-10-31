extends Control

var template_inv_slot = preload("res://Inventario/InvSlot/InvSlot.tscn")

onready var gridcontainer = $Background/M/GridContainer

func _ready():
	for i in PlayerData.inv_data.keys():
		var inv_slot_new = template_inv_slot.instance()
		
		if PlayerData.inv_data[i]["Item"] != null:
			var item_name = GameData.item_data[str(PlayerData.inv_data[i]["Item"])]["Name"]
			
			var icon_texture = load("res://Inventario/SpritesItens/"+ item_name +".tres")
			inv_slot_new.get_node("Item").set_texture(icon_texture)
			
		gridcontainer.add_child(inv_slot_new, true)
		
	
	#yield(get_tree().create_timer(0.35), "timeout")
	
func _process(delta):
	if Input.is_action_just_pressed("Abrir_Inv"):
		queue_free()
