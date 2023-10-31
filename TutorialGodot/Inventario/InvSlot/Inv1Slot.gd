extends TextureRect

onready var tool_tip = preload("res://Inventario/ToolTip/ToolTip2.tscn")



func get_drag_data(position):
	var inv_slot = get_parent().get_name()
	if PlayerData.inv_data[inv_slot]["Item"] != null:
		var data = {}
		data["origin_node"] = self
		data["origin_panel"] = "Inventory"
		data["origin_item_id"] = PlayerData.inv_data[inv_slot]["Item"]
		data["origin_equipment_slot"] = GameData.item_data[str(PlayerData.inv_data[inv_slot]["Item"])]["EquipmentSlot"]
		data["origin_texture"] = texture
		
		var drag_texture = TextureRect.new()
		drag_texture.expand = true
		drag_texture.texture = texture
		drag_texture.rect_size = Vector2(100,100)
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.rect_size = 0.2 * drag_texture.rect_size
		drag_texture.rect_position = -0.5 *drag_texture.rect_size
		
		set_drag_preview(control)
		
		return data

func can_drop_data(position, data):
#	return true
	var target_inv_slot = get_parent().get_name()
	if PlayerData.inv_data[target_inv_slot]["Item"] == null:
		data["target_item_id"] = null
		data["target_texture"] = null
		return true
	else:
		data["target_item_id"] = PlayerData.inv_data[target_inv_slot]["Item"]
		data["target_texture"] = texture
		if data["origin_panel"] == "CharacterSheet":
			var target_equipment_slot = GameData.item_data[str(PlayerData.inv_data[target_inv_slot])]["EquipmentSlot"]
			if target_equipment_slot == data["origin_equipment_slot"]:
				return true
			else:
				return false
			
func drop_data(position, data):
	var target_inv_slot = get_parent().get_name()
	var origin_slot = data["origin_node"].get_parent().get_name()
	
	if data["origin_panel"] == "Inventory":
		PlayerData.inv_data[origin_slot]["Item"] = data["target_item_id"]
	else:
		PlayerData.equipment_data[origin_slot] = data["target_item_id"]
	
	
	if data["origin_panel"] == "CharacterSheet" and data["target_item_id"] == null:
		pass#reseta o a imagem do slot
	else:
		data["origin_node"].texture = data["target_texture"]
		
		
	PlayerData.inv_data[target_inv_slot]["Item"] = data["origin_item_id"]
	var f = File.new()
	f.open("res://Json/inv_data_file.json", File.WRITE)
	f.store_string(JSON.print(PlayerData.inv_data, "  "))
	f.close()
	texture = data["origin_texture"]






func _on_Item_mouse_entered():
	var tool_tip_instance = tool_tip.instance()
	tool_tip_instance.origin = "Inventory"
	tool_tip_instance.slot = get_parent().get_name()
	
	#tool_tip_instance.rect_position = get_parent().get_global_transform_with_canvas().origin - Vector2(100,0)
	tool_tip_instance.rect_position.y = get_parent().get_global_transform_with_canvas().origin.y
	tool_tip_instance.rect_position.x = get_node("/root/World" + "/CanvasLayer/Inventario").get_global_transform_with_canvas().origin.x -53
	
	add_child(tool_tip_instance)
	yield(get_tree().create_timer(0.35), "timeout")
	if has_node("ToolTip") and get_node("ToolTip").valid:
		get_node("ToolTip").show()
		print("criadotooltip")




func _on_Item_mouse_exited():
	get_node("ToolTip").free()
