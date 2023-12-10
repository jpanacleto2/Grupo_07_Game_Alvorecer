extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():

	get_parent().show()
	
	#get_parent().set_scale.x = 2

# Called when the node enters the scene tree for the first time.
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			get_tree().quit()


func _on_Desisitir_mouse_entered():
	rect_size += Vector2(50,50)
	rect_global_position += Vector2(-4, -4)


func _on_Desisitir_mouse_exited():
	rect_size -= Vector2(50,50)
	rect_global_position -= Vector2(-4, -4)
