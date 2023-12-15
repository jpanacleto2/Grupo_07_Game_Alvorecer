extends Control

var template_inv_slot = preload("res://Inventario/InvSlot/InvSlot.tscn")
var posSelect = null
var podeSelect = true

onready var gridcontainer = $Background/M/GridContainer

func _ready():
	for i in PlayerData.inv_data.keys():
		var inv_slot_new = template_inv_slot.instance()
		
		if PlayerData.inv_data[i]["Item"] != null:
			var item_name = GameData.item_data[str(PlayerData.inv_data[i]["Item"])]["Name"]
			
			var icon_texture = load("res://Inventario/SpritesItens/"+ item_name +".tres")
			inv_slot_new.get_node("Item").set_texture(icon_texture)
			
			if GameData.item_data[str(PlayerData.inv_data[i]["Item"])]["Equipado"] == true:
				var slot_texture = load("res://Inventario/SlotEquipa.png")
				inv_slot_new.get_node("Slot").set_texture(slot_texture)

			
		gridcontainer.add_child(inv_slot_new, true)
	
	#yield(get_tree().create_timer(0.35), "timeout")
	
func _process(delta):
	##if Input.is_action_just_pressed("roll"):
		##var f = File.new()
		##f.open("res://Json/inv_data_file.json", File.WRITE)
		##f.store_string(JSON.print(PlayerData.inv_data, "  "))
		##f.close()
	
	if Input.is_action_just_pressed("Abrir_Inv"):
		var f = File.new()
		f.open("res://Json/inv_data_file.json", File.WRITE)
		f.store_string(JSON.print(PlayerData.inv_data, "  "))
		f.close()
		queue_free()
		
	if Input.is_action_just_pressed("Select") && PlayerData.inv_data["Inv" + str(posSelect)]["Item"] != null:
		if podeSelect:
			podeSelect = false
			get_node("Background/M/GridContainer/Inv" + str(posSelect)).get_node("Item").cria_Menu()
		else:
			podeSelect = true
	
	if Input.is_action_just_pressed("Select_Right") && podeSelect:
		if posSelect == null:
			posSelect = 1
			#PlayerData.inv_data["Inv" + posSelect]["Item"]
			get_node("Background/M/GridContainer/Inv" + str(posSelect)).get_node("Item").select = true
		else: 
			if posSelect + 1 < 30:
				get_node("Background/M/GridContainer/Inv" + str(posSelect)).get_node("Item").select = false
				posSelect += 1
				get_node("Background/M/GridContainer/Inv" + str(posSelect)).get_node("Item").select = true
	
	if Input.is_action_just_pressed("Select_Left") && podeSelect:
		if posSelect == null:
			posSelect = 1
			#PlayerData.inv_data["Inv" + posSelect]["Item"]
			get_node("Background/M/GridContainer/Inv" + str(posSelect)).get_node("Item").select = true
		else: 
			if posSelect - 1 > 0:
				get_node("Background/M/GridContainer/Inv" + str(posSelect)).get_node("Item").select = false
				posSelect -= 1
				get_node("Background/M/GridContainer/Inv" + str(posSelect)).get_node("Item").select = true
	if Input.is_action_just_pressed("Select_Down") && podeSelect:
		if posSelect == null:
			posSelect = 1
			#PlayerData.inv_data["Inv" + posSelect]["Item"]
			get_node("Background/M/GridContainer/Inv" + str(posSelect)).get_node("Item").select = true
		else: 
			if posSelect + 8 < 30:
				get_node("Background/M/GridContainer/Inv" + str(posSelect)).get_node("Item").select = false
				posSelect += 8
				get_node("Background/M/GridContainer/Inv" + str(posSelect)).get_node("Item").select = true
	if Input.is_action_just_pressed("Select_Up") && podeSelect:
		if posSelect == null:
			posSelect = 1
			#PlayerData.inv_data["Inv" + posSelect]["Item"]
			get_node("Background/M/GridContainer/Inv" + str(posSelect)).get_node("Item").select = true
		else: 
			if posSelect - 8 > 0:
				get_node("Background/M/GridContainer/Inv" + str(posSelect)).get_node("Item").select = false
				posSelect -= 8
				get_node("Background/M/GridContainer/Inv" + str(posSelect)).get_node("Item").select = true
			

func equipar(quadrinho, tipo):
	var categoria
	if tipo == 1:
		 categoria = "Weapon"
	else:
		 categoria = "Armor"
	
	#print(categoria)
	
	for i in PlayerData.inv_data.keys():
		var inv_slot_new = template_inv_slot.instance()
		if PlayerData.inv_data[i]["Item"] != null:
			if GameData.item_data[str(PlayerData.inv_data[i]["Item"])]["Equipado"] == true and GameData.item_data[str(PlayerData.inv_data[i]["Item"])]["Category"] == categoria:
				var slot_texture = load("res://Inventario/Slot.png")
				inv_slot_new.get_node("Slot").set_texture(slot_texture)
				GameData.item_data[str(PlayerData.inv_data[i]["Item"])]["Equipado"] = false
	
	var inv_slot_new = template_inv_slot.instance()
	var slot_texture = load("res://Inventario/SlotEquipa.png")
	GameData.item_data[quadrinho]["Equipado"] = true
	inv_slot_new.get_node("Slot").set_texture(slot_texture)


func descartar(quadradinho):
	quadradinho.get_node("Item").set_texture(null)
	
	
func atualiza():
	yield(get_tree().create_timer(0.005), "timeout")
	for i in PlayerData.inv_data.keys():
#		var inv_slot_new = template_inv_slot.instance()	
		if PlayerData.inv_data[i]["Item"] != null:
			if GameData.item_data[str(PlayerData.inv_data[i]["Item"])]["Equipado"] == true:
				var slot_texture = load("res://Inventario/SlotEquipa.png")
				get_node("Background/M/GridContainer/" + i).get_node("Slot").set_texture(slot_texture)
				#print("krl")
			else:
				var slot_texture = load("res://Inventario/Slot.png")
				get_node("Background/M/GridContainer/" + i).get_node("Slot").set_texture(slot_texture)
				#print("porra")
		else:
			var slot_texture = load("res://Inventario/Slot.png")
			get_node("Background/M/GridContainer/" + i).get_node("Slot").set_texture(slot_texture)


