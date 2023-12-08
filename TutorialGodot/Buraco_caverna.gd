extends Area2D

var entered = false

func _on_Buraco_caverna_area_entered(area):
	entered = true


func _on_Buraco_caverna_area_exited(area):
	entered = false
	
func _process(delta):
	if entered == true:
		get_tree().change_scene("res://Caverna.tscn")
