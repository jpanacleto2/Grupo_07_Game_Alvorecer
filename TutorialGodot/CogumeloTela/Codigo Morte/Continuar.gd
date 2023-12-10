extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var CheckPoint = get_tree().current_scene.Check
			var Player = get_tree().current_scene.Player
			Player.global_position = CheckPoint
			get_tree().reload_current_scene()
			#Player.respawn()
			#get_parent().queue_free()




func _on_Continuar_mouse_entered():
	rect_size += Vector2(50,50)
	rect_global_position += Vector2(-4, -4)


func _on_Continuar_mouse_exited():
	rect_size -= Vector2(50,50)
	rect_global_position -= Vector2(-4, -4)
