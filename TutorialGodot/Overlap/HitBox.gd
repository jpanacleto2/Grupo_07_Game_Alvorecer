extends Area2D

const SlashEffect = preload("res://Overlap/Porrada.tscn")
var active = false
var direction
export var damage = 0.5

func set_slash_direction(dir):
	direction = dir

func SlashEffect():
	if !active:
		var slashEffect = SlashEffect.instance()
		slashEffect.set_direction(direction)
		self.add_child(slashEffect)
		slashEffect.global_position = global_position
		print(global_position)
