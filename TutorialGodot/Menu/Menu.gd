extends Control


func _ready():

	OS.window_fullscreen = true
	


func _on_StartBtn_button_down():
	get_tree().change_scene("res://World/Mapa1.tscn")


func _on_StartBtn2_button_down():
	get_tree().quit()
