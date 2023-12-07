extends Node

var inv_data = {}

var equip_data = {
	"Armor": null,
	"Boots": null,
	"Sword": null
}


func _ready():
	var item_data_file = File.new()
	item_data_file.open("res://Json/inv_data_file.json", File.READ)
	var item_data_json = JSON.parse(item_data_file.get_as_text())
	item_data_file.close()
	inv_data = item_data_json.result
	#print(inv_data["Inv1"]["Item"])

