extends Node


var item_data = {}
var item_stats = ["Attack", "Defense", "Block", "PotionHealth", "PotionMana"]

func _ready():
	var item_data_file = File.new()
	item_data_file.open("res://Json/ItemData - Sheet1.json", File.READ)
	var item_data_json = JSON.parse(item_data_file.get_as_text())
	item_data_file.close()
	item_data = item_data_json.result


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
