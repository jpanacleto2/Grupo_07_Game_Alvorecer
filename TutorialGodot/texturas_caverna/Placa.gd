extends StaticBody2D

onready var text_box = $TextBox

func _ready():
	var width = text_box.rect_size[0]
	text_box.rect_position = Vector2(-width/2, -60)
