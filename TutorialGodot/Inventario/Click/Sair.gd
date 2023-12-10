extends TextureRect


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and Input.is_action_just_released("Click"):
			
			funcao()
			
func funcao():
	get_parent().queue_free()
